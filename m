Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab1DXLve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 07:51:34 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:47760 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab1DXLvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 07:51:32 -0400
X-Greylist: delayed 707 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Apr 2011 07:51:32 EDT
Date: Sun, 24 Apr 2011 11:32:47 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Michael Schmitz <schmitzmic@googlemail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <BANLkTi=vm-qs48-JySCpv+YHyC+9sO9U0A@mail.gmail.com>
Message-ID: <Pine.BSM.4.64L.1104241131460.8787@herc.mirbsd.org>
References: <1303317178.2587.30.camel@mulgrave.site>
 <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
 <20110421220351.9180.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com>
 <4DB3840F.3060503@gmail.com> <BANLkTi=vm-qs48-JySCpv+YHyC+9sO9U0A@mail.gmail.com>
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
> you'll have to restart your build Thorsten :-)

Heh okay, if you want. But only cross-compiling :D


KOSAKI Motohiro dixit:

>I think you are right. however I doubt m68k need to care memoryless node check.
>probably following patch just work.

That’s what we have now. Compiles, boots, works fine.


So, which of these do you guys want?

bye,
//mirabilos
-- 
13:47⎜<tobiasu> if i were omnipotent, i would divide by zero
                all day long ;)
(thinking about http://lobacevski.tumblr.com/post/3260866481 by waga)
