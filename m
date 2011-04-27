Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab1D0Upd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:45:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57751 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab1D0Upc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikq34nGQU=1U4uvrSu_mRPf-UjLRg@mail.gmail.com>
References: <BANLkTikq34nGQU=1U4uvrSu_mRPf-UjLRg@mail.gmail.com>
From: Joost Pjotr Vermeer <jp@df5ea.net>
Date: Wed, 27 Apr 2011 22:45:11 +0200
Message-ID: <BANLkTikzQtZuFHKqtaiwc=djz5q7m6w4DA@mail.gmail.com>
Subject: Re: backlight control broken on Sony VGN-P21Z with staging/gma500
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: jp@df5ea.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/4/13 Joost Pjotr Vermeer <jp@df5ea.net>:
> I tried the new gma500 driver from staging on my Sony VGN-P21Z. It
> seems to work very nice.
>
> But backlight control does not work. It has worked with a previous
> version of the staging/gma500 driver. I can solve it by removing the
> call to acpi_video_register() from psb_driver_load() in psb_drv.c.

I retried using 2.6.39-rc4 and now I have two backlight devices:

 - /sys/class/backlight/acpi_video0 and;
 - /sys/class/backlight/psb-bl

The psb-bl one works, the acpi_video0 one does not.

      — Joost
