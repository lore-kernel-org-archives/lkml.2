Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1BDUXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:23:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1BDUXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:23:30 -0500
From: "Dr. Martin Rogge" <marogge@onlinehome.de>
To: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: scheduling policy    was: Re: 2.6.37 considered stable?
Date: Fri, 4 Feb 2011 21:23:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-ck1; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102042123.28734.marogge@onlinehome.de>
X-Provags-ID: V02:K0:bNWyu5AQfJFa3w13AmU5TNTYOQro9GjKZlcMX6mC2/3
 R2LseMdEyM6KUIdmU5zaXqqq8OMjbBtCDvOY4jX1QlGxqPhJnN
 UbH9Dh+p8fPfVpPq26YptbEP5ZSu6gybbq5MW0L/QwI86VURcR
 Mu19Ail/fEzGlYvzMydz1C9GZkMeQTPoSAaSEwaImbhEK1QvYg
 lF2ii1YIwmq7OO4DK+XxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Chuckle.  I've been running 2.6.37 here, with all of that new group
> scheduling stuff enabled, the desktop feels great and my only fuss is that
> kaffiene, when watching digital tv on my pcHD-3000 card, is NOT getting
> enough time so both the audio and the video have little 20 millisecond
> holes chopped in them at sub-second intervals.  Not the most pleasant
> thing
> to watch.  I would appreciate any suggestions on how to get such an
> application a higher priority.
> 

Gene, have you tried schedtool to set the scheduling policy of the process to 
SCHED_FIFO or even SCHED_ISO? 

Before anyone asks, yes, relying on schedtool puts a little reponsibility on 
user space, but it is my firm believe that (a) you can't auto-everything and 
(b) the onus should be on the distro not the user.

Martin
