Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab1D0PQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:16:41 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:1229 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1D0PQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:16:40 -0400
Date: Wed, 27 Apr 2011 15:09:23 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Michael Schmitz <schmitzmic@googlemail.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <BANLkTin3BmJpuzUyBWV1B38oVMDbXe=fbw@mail.gmail.com>
Message-ID: <Pine.BSM.4.64L.1104271508340.29189@herc.mirbsd.org>
References: <1303317178.2587.30.camel@mulgrave.site>
 <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
 <20110421220351.9180.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com>
 <4DB3840F.3060503@gmail.com> <alpine.DEB.2.00.1104251355410.31884@chino.kir.corp.google.com>
 <4DB63349.3070808@gmail.com> <Pine.BSM.4.64L.1104261049350.4851@herc.mirbsd.org>
 <BANLkTin3BmJpuzUyBWV1B38oVMDbXe=fbw@mail.gmail.com>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven dixit:

>Fixed those up, applied, and will send to Linus for 2.6.39-final.

Tested-by: Thorsten Glaser <tg@debian.org>

>BTW, if I enable CONFIG_SLUB on my ARAnyM setup, I don't get a crash, but it
>hangs after:

I think that’s toolchain, environment, etc. dependent…

>With Michael's patch, it continues fine.

Yeah, same here.

bye,
//mirabilos
-- 
FWIW, I'm quite impressed with mksh interactively. I thought it was much
*much* more bare bones. But it turns out it beats the living hell out of
ksh93 in that respect. I'd even consider it for my daily use if I hadn't
wasted half my life on my zsh setup. :-) -- Frank Terbeck in #!/bin/mksh
