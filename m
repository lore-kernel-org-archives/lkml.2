Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab1DXMTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 08:19:35 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:35462 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab1DXMTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 08:19:32 -0400
Date: Sun, 24 Apr 2011 12:18:04 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Michael Schmitz <schmitzmic@googlemail.com>
cc: David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <4DB3840F.3060503@gmail.com>
Message-ID: <Pine.BSM.4.64L.1104241216190.8787@herc.mirbsd.org>
References: <1303317178.2587.30.camel@mulgrave.site>
 <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
 <20110421220351.9180.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com>
 <4DB3840F.3060503@gmail.com>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schmitz dixit:

> Tested on my ARAnyM test setup so far. I'd like to wait for an independent
> kernel image built by Thorsten before I test on the actual hardware. Sorry but

ARAnyM too, but both this patch and the earlier one compile and boot
(on atari) and I’m building packages under both of them (two ARAnyM
instances) right now. Toolchain used:

binutils-m68k-linux-gnu         2.21.51.20110419-2
gcc-4.4-m68k-linux-gnu          4.4.6-2+m68k.1

(i.e. sid latest; gcc with only a patch to keep building libgcc2,
since we don’t have gcc-4.5 on m68k yet)

bye,
//mirabilos
-- 
13:47⎜<tobiasu> if i were omnipotent, i would divide by zero
                all day long ;)
(thinking about http://lobacevski.tumblr.com/post/3260866481 by waga)
