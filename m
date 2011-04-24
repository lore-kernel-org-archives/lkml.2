Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1DXTQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 15:16:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49900 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab1DXTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 15:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=RgCxuvOwjYj+mZMp+lxEHeXxqj5ZaAi9sPIbM7VM3mAaSqyGSDaLQXKSq59qd2Q0sg
         qO20e7eBHVs0mHtDgICXqh/GbOssIy3puVq29FNyoFGPOGdjUPlQw/DBEIsvWsonQDpk
         EvEBSg1DC5PQ5GaStgM2TkivXJhibIq2VSJ/A=
MIME-Version: 1.0
From: Tyler Earman <rem.intellegare@gmail.com>
Date: Sun, 24 Apr 2011 14:15:54 -0500
Message-ID: <BANLkTikvHJ583KaTZcK8p8Ckhs-_fm3tDA@mail.gmail.com>
Subject: Massive load average spikes tracing the cause
To: linux-kernel@vger.kernel.org
Cc: Tyler Earman <rem.intellegare@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me if you would.


Basically, I'm running a machine that will have massive load average
spikes (up into the 5-10 range on a 2 CPU machine) at seemingly random
intervals.  I've tried most normal tracing conventions but now I'm
going to have to delve into the kernel to find out exactly what's
going on here.

The kernel does softlock occasionally on this event, but the CPU usage
stays very low (1-10%).

I'm guessing this is an I/O lockup somewhere, but the question is /where/.

So, in short, how would I go about hooking into the kernel directly to
try and find these problems?  Is there a way to watch just about
everything going on when these events happen?

Thanks for the help,
Tyler
