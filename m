Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab2JUEUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 00:20:17 -0400
Received: from [216.32.180.187] ([216.32.180.187]:8597 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab2JUEUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 00:20:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VPS6(zzbb2dI98dI9371I103dK1432Izz1202h1d1ah1d2ahzz177df4h17326ah8275bh8275dhf73b6uz2dh668h839h944hd25hd2bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1155h)
X-WSS-ID: 0MC86NM-02-A12-02
X-M-MSG: 
Date: Sat, 20 Oct 2012 23:18:58 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Tom Rini <trini@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
Message-ID: <20121021041858.GA14809@jshin-Toonie>
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur>
 <d556fc0f-da5d-4531-b331-6dc086461f34@blur>
 <50833F30.4020802@ti.com>
 <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 09:01:43PM -0700, Yinghai Lu wrote:
> On Sat, Oct 20, 2012 at 5:17 PM, Tom Rini <trini@ti.com> wrote:
> > On 10/20/12 17:11, Shin, Jacob wrote:
> >> Hi could you please attach the dmesg output? Before rc2 is fine as well.
> >> I would like to see the E820 table. Thank you,
> >
> > dmesg is quite long so I've put it on pastebin: http://pastebin.com/4eSPEAvB
> >
> > --
> 
> [    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000042fffffff] usable
> 
> pre-calculate table size is too small, so it crashes.

Right,

I think just this one patch 3/6 on top of -rc2 should work:

https://lkml.org/lkml/2012/8/29/223

That would be a simpler path for 3.7,

Thanks!

> 
> can you please try
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm
> 
> and post bootlog?
> 
> Thanks
> 
> Yinghai
> 

