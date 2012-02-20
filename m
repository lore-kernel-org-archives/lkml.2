Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2BTMLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 07:11:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2BTMLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 07:11:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bernhard Walle <bernhard@bwalle.de>
Subject: Re: [PATCH] misc: bmp085: Handle jiffies overflow correctly
Date: Mon, 20 Feb 2012 12:10:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: christoph.mair@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <1329672481-19583-1-git-send-email-bernhard@bwalle.de>
In-Reply-To: <1329672481-19583-1-git-send-email-bernhard@bwalle.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202201210.54472.arnd@arndb.de>
X-Provags-ID: V02:K0:tN6I9Uy7wZwqJr6CquQhBiyZmsouzPpaZgYzE0tyqjj
 KVf8cF8Qh8GGxU5CRTBeGpVEAnwDh233kQUQKDq7/r+j5BUD9G
 S1kV7eabocLHH0ZztY6222FksHjD0z4F/cRU/2G2Fl1lMCPZMg
 2Ac9L5THwkYeefOTqb+bI2zV9CeKRxH4UZXyXYrE1ryo1LNgGJ
 PrQd0FaortROUyT2BP8W/eLZUzb32vnCbBMUhl0mw3dxxM9iDW
 rAz/3dR086CrTBMrdoBSOBDeI/FICZ0vVSqN0Nhar/3sYIcj2y
 eoOCZXxL7SKUk55nQKpxWJnR9xfpOeJ9bI1yU5zzgvT2HTKp8S
 0tvx1Zo6jWNl8zP9wOvM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 February 2012, Bernhard Walle wrote:
> By using the time_is_before_jiffies() macro instead of normal
> arithmetic, the jiffies overflow is handled correctly.
> 
> Signed-off-by: Bernhard Walle <bernhard@bwalle.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

BTW, what is the future of this driver? Are there
plans to move it over to the the industrial I/O
framework?

	Arnd
