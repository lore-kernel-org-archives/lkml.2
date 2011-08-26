Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1HZMmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:42:00 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:53237 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1HZMl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:41:59 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Aug 2011 08:41:58 EDT
X-ME-engine: default
Date: Fri, 26 Aug 2011 14:33:58 +0200
From: Bastien Dejean <eschyle@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Limited Brightness Values with apple_backlight on an iMac 10,1
Message-ID: <20110826123358.GA13479@circle.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since 2.6.39 I have a /sys/class/backlight/apple_backlight/ interface
and I can change the brightness by echoing values to the relevant
brightness file.

That's great but there's a little problem:

On the 256 levels of brightness that my screen supports, I can only reach
16 of the 128 upper values. It means that the lowest brightness I can
access on Linux is at 50% of the real maximum brightness.

Thanks,
-- 
Bastien
