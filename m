Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2AAXNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 18:13:07 -0500
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:6970 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab2AAXMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 18:12:55 -0500
Date: Sun, 1 Jan 2012 23:12:00 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: linux-kernel@vger.kernel.org
cc: 648996@bugs.debian.org
Subject: Re: Bug#648996: linux-2.6: FTBFS [m68k] in modpost: "strlen"
 [iscsi_target_mod.ko] undefined! (and others)
In-Reply-To: <Pine.BSM.4.64L.1112181929380.856@herc.mirbsd.org>
Message-ID: <Pine.BSM.4.64L.1201012310590.20109@herc.mirbsd.org>
References: <20111116181424.14920.7730.reportbug@ara5.mirbsd.org>
 <Pine.BSM.4.64L.1111301751500.12725@herc.mirbsd.org>
 <CAMuHMdW8t8Q7OqxJM602iLG4aSv1KMTY-fhiGS7hyy8xBReh1A@mail.gmail.com>
 <Pine.BSM.4.64L.1112181741430.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1112181929380.856@herc.mirbsd.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dixi quod…

>So, please, compile the Linux kernel with -ffreestanding, too.

Just to keep this bugreport in the loop: that fixes the FTBFS error.
http://lists.debian.org/debian-68k/2012/01/msg00000.html

bye,
//mirabilos
-- 
<dileks> ch: good, you corrected yourself. ppl tend to tweet such news
immediately, sth. like "grml devs seem to be buyable"    <ch> dileks: we
_are_. if you throw enough money in our direction, things will happen
<mika> everyone is buyable, it's just a matter of price   <mrud> and now
comes [mira] and uses this as a signature ;0	   -- they asked for it…
