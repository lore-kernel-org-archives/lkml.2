Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1DDPq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:46:56 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:38800 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1DDPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:46:55 -0400
X-IronPort-AV: E=Sophos;i="4.63,298,1299456000"; 
   d="scan'208";a="5130047"
Date: Mon, 4 Apr 2011 16:47:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ingo Molnar <mingo@elte.hu>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
In-Reply-To: <20110404151132.GC11475@elte.hu>
Message-ID: <alpine.DEB.2.00.1104041616550.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <20110401062338.GA6434@elte.hu> <alpine.DEB.2.00.1104011212070.16492@kaball-desktop> <20110401190812.GA16830@elte.hu> <alpine.DEB.2.00.1104012318390.16492@kaball-desktop>
 <20110404151132.GC11475@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011, Ingo Molnar wrote:
> 
> * Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > Just to clarify the situation the patch "x86-64: finish cleanup_highmaps()'s 
> > job wrt. _brk_end" was backported to the stable trees [...]
> 
> There's no commit with such a title upstream - there's not even one that is 
> close. Could you cite the sha1 you refer to?

The commit id upstream is 498343967613183611ac37dccb2846496d954c06


> > [...] (including Jeremy's 2.6.32 xen tree because he pulled from 2.6.32.y) 
> > breaking boot on xen.
> 
> Basing upstream-relevant trees on stable backported sha1's is a very, very bad 
> idea.

We are not using Jeremy's 2.6.32 tree for development anymore, we
develop on upstream directly.


> > Yinghai's patch plus another patch of mine fix that breakage and that is why 
> > I ask for it to be backported.
> 
> So it fixes a commit that is nowhere to be found upstream?

It fixes 498343967613183611ac37dccb2846496d954c06, if you are interested
in all the details of the conversation with Yinghai and Peter, here are
a couple of links to the lkml archives:

https://lkml.org/lkml/2011/1/31/232
https://lkml.org/lkml/2011/2/28/410

