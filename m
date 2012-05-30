Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2E3P6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:58:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48848 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2E3P6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:58:53 -0400
Date: Wed, 30 May 2012 17:58:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andre Przywara <andre.przywara@amd.com>, Jacob Shin <Jacob.Shin@amd.com>,
        mingo@elte.hu, jeremy@goop.org, tglx@linutronix.de,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530155850.GD15438@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Beulich <JBeulich@suse.com>,
	Andre Przywara <andre.przywara@amd.com>,
	Jacob Shin <Jacob.Shin@amd.com>, mingo@elte.hu, jeremy@goop.org,
	tglx@linutronix.de, xen-devel@lists.xensource.com,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <4FC649790200007800086E51@nat28.tlf.novell.com>
 <4FC631F0.9080109@zytor.com>
 <20120530144929.GH3207@phenom.dumpdata.com>
 <20120530151235.GB15635@x1.osrc.amd.com>
 <4FC65B950200007800086F5B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC65B950200007800086F5B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 04:40:37PM +0100, Jan Beulich wrote:
> >>> On 30.05.12 at 17:12, Borislav Petkov <bp@alien8.de> wrote:
> > This current case should be a perfect example for why xen shouldn't be
> > sprinkling code all over the place.
> 
> Which means you're denying the benefits of para-virtualization

Does it really mean that?

> (at the base system level; perhaps it's less of a problem for
> you when it comes to pv device drivers, which are generally
> standalone entities) as that's what distinguishes Xen from all other
> virtualization solutions Linux supports.

All I'm saying is, xen should solve the whole deal of what it wants to
do (whatever that is) _without_ and _agnostic_ from arch/x86/. Otherwise
x86 changes break xen.

I couldn't care less about what distinguishes xen from all other
solutions.

-- 
Regards/Gruss,
Boris.
