Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab2AVIFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 03:05:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50657 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2AVIFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 03:05:17 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Mantas <grawity@gmail.com>
Subject: Re: 3.2-git - freeze during hibernation
Date: Sun, 22 Jan 2012 09:05:10 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, suspend-devel@lists.sourceforge.net,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <jepbo0$l1e$1@dough.gmane.org>
In-Reply-To: <jepbo0$l1e$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201220905.10710.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Add CC to Rafael)

On piątek, 13 stycznia 2012 o 14:31:44 Mantas wrote:
> Using uswsusp git-17789a0 and Linux git-v3.2-6540-g4c4d285, suspend to
> disk freezes right before writing the memory to disk -- "Saving X image
> data pages" appears, but the percentage does not, nor is there any disk
> activity; all I can do is reboot using Alt+SysRq.
> 
> Same version of uswsusp, both suspend to memory and disk, worked
> perfectly with Linux v3.2 release and earlier versions. The device is
> ASUS K52JT. Any hints?

-- 
Maciej Rutecki
http://www.mrutecki.pl
