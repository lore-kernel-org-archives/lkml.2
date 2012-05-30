Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2E3Qzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:55:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36260 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2E3Qzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:55:50 -0400
Date: Wed, 30 May 2012 12:48:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: jeremy@goop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andre Przywara <andre.przywara@amd.com>, xen-devel@lists.xensource.com,
        stable@vger.kernel.org#3.4+, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530164836.GB12109@phenom.dumpdata.com>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <20120530143937.GF3207@phenom.dumpdata.com>
 <4FC633A7.1050406@zytor.com>
 <4FC6540E0200007800086EF7@nat28.tlf.novell.com>
 <4FC63996.9040706@zytor.com>
 <4FC65A6D0200007800086F35@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC65A6D0200007800086F35@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 04:35:41PM +0100, Jan Beulich wrote:
> >>> On 30.05.12 at 17:15, "H. Peter Anvin" <hpa@zytor.com> wrote:
> > On 05/30/2012 08:08 AM, Jan Beulich wrote:
> >> 
> >> Xen does trap and emulate (possibly just ignore) both instructions.
> >> 
> > 
> > Then why the fsck is there paravirt_crap on this?
> 
> I have no clue. Jeremy, Konrad?

No idea. The git 132ec92f says:

Borislav Petkov <petkovbb@googlemail.com>
Date:   Mon Aug 31 09:50:09 2009 +0200

    x86, msr: Add rd/wrmsr interfaces with preset registers

    native_{rdmsr,wrmsr}_safe_regs are two new interfaces which allow
    presetting of a subset of eight x86 GPRs before executing the rd/wrmsr
    instructions. This is needed at least on AMD K8 for accessing an erratum
    workaround MSR.

    Originally based on an idea by H. Peter Anvin.

