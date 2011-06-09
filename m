Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1FIVFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:05:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55038 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1FIVFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:05:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 7/7] [v6] drivers/virt: introduce Freescale hypervisor management driver
Date: Thu, 9 Jun 2011 23:04:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Timur Tabi <timur@freescale.com>, alan@lxorguk.ukuu.org.uk,
        kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, cmetcalf@tilera.com, konrad.wilk@oracle.com,
        dsaxena@linaro.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1307652726-4356-1-git-send-email-timur@freescale.com>
In-Reply-To: <1307652726-4356-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106092304.55479.arnd@arndb.de>
X-Provags-ID: V02:K0:egpVF0OiWgiL6LoRsKrnViy0jnRLARtTUnuc9jnfIpE
 T3oKYOlub6r0QEDOAynuWYYLKGLUHHXNigEzFII+KF1x7HeZuw
 riSR6pOy/U2SFhDKAx4+r4JYvy40ygXCJsvnRIel8OXmnjC0ef
 CAlcQTjBiCwdwYeD7LD4EKNFdzPFNYw2M4pg/QkpkOqWzH0uZ8
 RKjIpWDGCIEHft1cvsAgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 22:52:06 Timur Tabi wrote:
> Add the drivers/virt directory, which houses drivers that support
> virtualization environments, and add the Freescale hypervisor management
> driver.
> 
> The Freescale hypervisor management driver provides several services to
> drivers and applications related to the Freescale hypervisor:
> 
> 1. An ioctl interface for querying and managing partitions
> 
> 2. A file interface to reading incoming doorbells
> 
> 3. An interrupt handler for shutting down the partition upon receiving the
>    shutdown doorbell from a manager partition
> 
> 4. A kernel interface for receiving callbacks when a managed partition
>    shuts down.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
