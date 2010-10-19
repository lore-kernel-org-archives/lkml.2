Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0JSRft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:35:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab0JSRfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:35:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] linux-firmware: Add firmware file for r8712u (RTL8192SU)
Date: Tue, 19 Oct 2010 19:35:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-next-20101015+; KDE/4.5.1; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <4cbdbf3b.Ek+PDAiA1jX27HRq%Larry.Finger@lwfinger.net> <1287504505.1084.23.camel@i7.infradead.org> <4CBDC6AF.3060902@lwfinger.net>
In-Reply-To: <4CBDC6AF.3060902@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191935.40788.arnd@arndb.de>
X-Provags-ID: V02:K0:MpLesXzgZi+ijnUnm/3QT6NFq+M/8FytPAzRMGnBjvh
 OJQNWLs5jH2VjBGNxE6OBaa+7Xl8TkQyiG+SSj9CbagC02DOb/
 C5jSE0rQ1cSk4X1zwJJEF+yIZOlfJUumH7tWyTL/ELwUjSxL++
 LbSsK/Rq/aIRzxiHRta/R9G9n2Ts6x/0lqvy8yV2QaXnC5ViV1
 eF/jfP8IGTd6tHJy2v0yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010 18:26:23 Larry Finger wrote:
> The license information that I put into WHENCE is in the source-code file that
> contains the MODULE_LICENSE(GPL) statement. As the firmware header file is part
> of that set of files, I thought the GPL license would apply to all. Is that not
> so? If not, I'm not sure how to proceed.

In theory, the person that added the firmware files to the kernel under the
terms of the GPL or anyone who distributed them before should be able to provide
the source code for the firmware.

If you think that the driver has been developed legally, just ask the author
of the firmware for the source and add it to your patch.

If you don't think it was done correctly, try to get a license for redistributing
the firmware as binary and list the license terms in the WHENCE file.

Hint: some files of the driver contain these "interesting" conditions:

/*
 * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
 * Linux device driver for RTL8192U
 *
 * Based on the r8187 driver, which is:
 * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.

	Arnd
