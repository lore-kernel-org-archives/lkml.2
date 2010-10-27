Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0J0UTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:19:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0J0UTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:19:12 -0400
From: "Dr. Martin Rogge" <marogge@onlinehome.de>
To: linux-kernel@vger.kernel.org
Subject: Re: several problems with intel graphics since 2.6.36
Date: Wed, 27 Oct 2010 22:19:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-ck1; KDE/4.5.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010272219.10225.marogge@onlinehome.de>
X-Provags-ID: V02:K0:o3FmLEWDnSmwWCMwrRTM8AxAXeJ/vhr/thXN49xut/I
 yobSBfnrPSzmSlhpMgJhGvfPf357b0qjA2jCQdzfIE0fWhYCgH
 hPBc6Y0Dnm8xDm9plDqA4QV9X5nZh9p/eM/MGWEoCcawCCJCO1
 BS1mfZAKDyKgyJBwnStD1o3XyKLNsh61ZN34R8IvtJgzQnWlhy
 m2QQRekMs1/X9azuEhB0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norbert Preining wrote:

> Dear all,
> 
> I have the feeling that 2.6.36 has introduced many regressions
> concerning Intel graphics card.
> 

my experience is slightly different: 2.6.35 introduced a sporadic suspend 
issue on a laptop (GM45 based) that has never been fixed but disappeared early 
on in 2.6.36. (https://bugzilla.kernel.org/show_bug.cgi?id=16532)

on another machine (i3 Clarkdale based) 2.6.36 introduced a sporadic cold X 
freeze, somtimes logging a kernel bug, sometimes affecting the process 
scheduler. (https://bugzilla.kernel.org/show_bug.cgi?id=20452)

>From the day I built that i3 machine (2.6.33 or 2.6.34) it has had issues with 
the 64 bit flash plugin, resulting in an X crash eventually when repeatedly 
maximising/minimising a flash video. However, this issue might not be kernel 
related. (https://bugs.freedesktop.org/show_bug.cgi?id=26937 )

One of the vblank fixes (presumably) in 2.6.35 or 2.6.36 now causes a few dark 
periods during initialisation. (no bug report)

I try and bisect where I can, but often the issues are sporadic and bisecting 
just ends up being a waste of time.

Martin
