Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab2DDTwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:52:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab2DDTwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:52:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Andersson <eric.andersson@unixphere.com>
Subject: Re: [PATCHv3 0/3] bmp085: add support for bmp18x chip
Date: Wed, 4 Apr 2012 19:52:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com, stefan.nilsson@unixphere.com,
        broonie@opensource.wolfsonmicro.com
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com>
In-Reply-To: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204041952.34241.arnd@arndb.de>
X-Provags-ID: V02:K0:ULUTTIvWw9tlXcS0hNLOYnaOKWYzfQfkOR5d0TyEl6f
 vS+0gURTeUUmBKBzKQ+Fo8263VLJ4NPpPfTyTsCsA/zxFo++8S
 8V0A8aMEHme2MYRjPRIPNZVMFG6aVMdP6hxWsum+Ho2NGUsrX1
 VWCNSiweZGESAkeJHnvvmKA0TcpbEwV1+tml4dif3FvscozUak
 U8vOi82kNJzA+p/cE3d1jADWFZwV7KIK6rSen6nZTV78xLO6WI
 MoNnkQivkE9H0Uvqadr/TLGmusrpvXQTKsYaTb9a51KwencRrA
 impq1Wh9T6XWFP2h+ZNgC0hUhA/wPXgF847vxkwgbPii3kLXug
 wfvByEGIxXIYEiqN0rDc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2012, Eric Andersson wrote:
> This is version 3 of the patch-set that adds support for the latest pressure
> sensors from Bosch Sensortec.
> 
> Changes from last version:
> - Dropped the platform data in favor of devicetree properties.
> - Use regmap as communication layer.
> - Changed Kconfig logic.
> - Keep the original bmp085 file name.
> - Use EXPORT_SYMBOL_GPL.
> 
Looks all good to me now,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
