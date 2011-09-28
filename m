Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1I1O6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:58:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab1I1O6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:58:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 05/24] C6X: build infrastructure
Date: Wed, 28 Sep 2011 16:57:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <201109281523.15680.arnd@arndb.de> <1317220372.2580.68.camel@deneb.redhat.com>
In-Reply-To: <1317220372.2580.68.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281657.59636.arnd@arndb.de>
X-Provags-ID: V02:K0:reXIeelkUcc55eUIYTi6VOEMBQFBN7BkxLz9pNiTqRK
 ol/34qiRaXgcogh70pkdxNzGUx7350vrLkO0xjSr0GYKVzFb6+
 LdtmsWcziF8uHw/J+zg/1SzMn5HGAMvQkWtyNPvVZ+rfoQaMwJ
 LQhY5U4MQodcQKpzERMZTNKVDxEyNGAOYHW7moIbGXHEs3ETvh
 9ClclAy/5/YFGi8Bu1qN2xp8+4OjPE3BBDSf48eyxDK1Vw8PLh
 NVcnBnHYIo17b6i6F8jYpSyLy2uFWJTxXlObwI0U6vXJoXWrCn
 U5vmUCSZ0EzxV7I4tul4rslpDq0pJKxbJRcTVe//nrVsmIPeYc
 cbeq0+Mwx6QczvMbIBFY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, Mark Salter wrote:
> > Also, how different are these boards and socs still? Since you are
> > based on device trees for hardware configuration, do you actually
> > need the options at all?
> 
> The BOARD configs can go. The SOC configs will go out when clkdev
> stuff gets reworked when generic clock bindings are available.
> 
Ok, sounds good.

	Arnd
