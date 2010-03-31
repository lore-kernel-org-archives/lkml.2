Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0CaOpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:45:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab0CaOpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:45:15 -0400
Date: Wed, 31 Mar 2010 16:45:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andre Przywara <andre.przywara@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2,
 stepping 3
In-Reply-To: <4BB35EB5.5060402@amd.com>
Message-ID: <alpine.LNX.2.00.1003311644520.24576@pobox.suse.cz>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org> <4BB33C0D.9090808@amd.com> <alpine.LNX.2.00.1003311531000.24576@pobox.suse.cz> <4BB35EB5.5060402@amd.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Andre Przywara wrote:

> > > BTW.: I encourage people to test their KVM guests with "-cpu host" (on
> > > newer
> > > QEMUs) and send me any crash logs.
> > 
> > I just quickly checked ...
> > 
> snip
> > [    0.147235]  [<c0528a80>] init_amd+0x249/0x279
> > [    0.148011]  [<c0527d74>] identify_cpu+0xc2/0x223
> > [    0.149649]  [<c078822d>] identify_boot_cpu+0xa/0x22
> > [    0.152010]  [<c07882c8>] check_bugs+0x8/0xd2
> > [    0.153573]  [<c0781a05>] start_kernel+0x32e/0x3a9
> > 
> > But I admit that this isn't the most up-to-date version, so perhaps it's
> > already fixed ...
> No, that is something new. I dug out the kernel (SLES 11.1?) and booted with
> my script, it crashed on FMS 16/9/0, so I guess this machine was a
> Magny-Cours, right?

Yup, it's cpu family 10h.

> Anyway, many thanks for the report, I will investigate this.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
