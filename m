Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1F1UXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:23:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1F1UXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:23:44 -0400
From: Martin <marogge@onlinehome.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #37752] Kernel Panic in drm_vblank_put+0x13/0x50 on P4 HT machine with 82915G/GV/910GL Integrated Graphics Controller
Date: Tue, 28 Jun 2011 22:23:40 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39.1-ck2; KDE/4.5.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera> <Rm1pgFxEGUF.A._PE.UM7BOB@chimera>
In-Reply-To: <Rm1pgFxEGUF.A._PE.UM7BOB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106282223.40536.marogge@onlinehome.de>
X-Provags-ID: V02:K0:Y4D2HCKt5xV+kmYNeOGCJCxghPcl4hVmL84FMlTk1K3
 HBhnJgX6nTrsakaHBhoSYgEntlt5URqfh2wnWNXl3hKbIGGsTb
 1WjawGlNDW8O3/RoyXzRXXVnLT5kJMC/pVcOaMCScHwHZnwMNl
 iDhKgwDgcCTqqAVxHEa8VcZI8TrubX37ZT2/hHva+Uu/YfNev5
 9bm359toDZl/PUNwFwYlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 June 2011 00:35:16 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37752
> Subject		: Kernel Panic in drm_vblank_put+0x13/0x50 on P4 HT machine 
with
> 82915G/GV/910GL Integrated Graphics Controller Submitter	: Martin Rogge
> <marogge@onlinehome.de>
> Date		: 2011-06-17 13:02 (10 days old)

As far as I can see the bug is still present in the 2.6.39 line. However. I 
have good news. Out of a whim I've been trying 3.0-rc4 and the panic has not 
occurred in a few days.

I can try and bisect which commit fixed the issue. I guess I have to reverse 
the semantics of good and bad for this one. Don't tell the clergy.

Anyway, since it takes a while to establish the absence of a panic, don't 
expect any results soon.

Martin
