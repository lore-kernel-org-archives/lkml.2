Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2E3Pkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:40:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52299 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2E3Pkl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Wed, 30 May 2012 11:40:41 -0400
Message-Id: <4FC65B950200007800086F5B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 30 May 2012 16:40:37 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@alien8.de>
Cc: "Andre Przywara" <andre.przywara@amd.com>,
        "Jacob Shin" <Jacob.Shin@amd.com>, <mingo@elte.hu>, <jeremy@goop.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com>
 <4FC649790200007800086E51@nat28.tlf.novell.com>
 <4FC631F0.9080109@zytor.com> <20120530144929.GH3207@phenom.dumpdata.com>
 <20120530151235.GB15635@x1.osrc.amd.com>
In-Reply-To: <20120530151235.GB15635@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.12 at 17:12, Borislav Petkov <bp@alien8.de> wrote:
> This current case should be a perfect example for why xen shouldn't be
> sprinkling code all over the place.

Which means you're denying the benefits of para-virtualization
(at the base system level; perhaps it's less of a problem for you
when it comes to pv device drivers, which are generally
standalone entities) as that's what distinguishes Xen from all
other virtualization solutions Linux supports.

Jan

