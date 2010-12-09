Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0LIWRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:17:46 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:42858 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0LIWRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:17:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RjN+l7kV4bqgBOgGv9m+LEmkTbPopWq+P+vBmAwmekIgBDoa5UFlz/QgBF3tqKLHIb
         VzrXuaOwZCEcLpHFzkhIaHjr+7zOLn3Y9R43ymIa3pPjwSahNoLK653PWFKdfCly/yM2
         a7vXGz2KHh7Nt9FMOXErl+6RGNODrylK+W5qk=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Peter Huewe <peterhuewe@gmx.de>
Subject: Re: [PATCH] leds/h1940: Use gpiolib for latch access / fix build failure
Date: Fri, 10 Dec 2010 00:16:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3-anarsoul; KDE/4.5.4; i686; ; )
Cc: Ben Dooks <ben-linux@fluff.org>, Vincent Sanders <support@simtec.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1291932292-16049-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1291932292-16049-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012100016.58130.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 December 2010 00:04:52 Peter Huewe wrote:
> This patch fixes a build failure by converting leds-h1940.c to use
> gpiolib for latch access introduced by 14477095abc6
> (ARM: h1940: Use gpiolib for latch access)
> 
> Unfortunately this driver was not converted back then.

I sent similar patch (however, my patch does gpio_request/gpio_free) ~month 
ago.

Here's link:
http://www.spinics.net/lists/arm-kernel/msg103429.html

Regards
Vasily
