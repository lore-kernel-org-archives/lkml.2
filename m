Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2B2USw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:18:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab2B2USv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:18:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Andersson <eric.andersson@unixphere.com>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Date: Wed, 29 Feb 2012 20:18:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        christoph.mair@gmail.com, stefan.nilsson@unixphere.com,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Jonathan Cameron <jic23@cam.ac.uk>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
In-Reply-To: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202292018.45557.arnd@arndb.de>
X-Provags-ID: V02:K0:8DGutqzox+uf8xj3htjy6VN4MXZ1fYoPKt51VjqI21M
 7Uk4XIENT6XPD+I5ZETiow9W0XHJoPZEe/LdzU7voQ53osU39u
 8xf+kAVKDSIctrgElnJCwToRpNsx+7qDrbQsmaa5a30IVaqZ1+
 Z3V5HZnfwVg0usLP1XklE5WuTCAT04W39Oz3bK3iJyk/e91/92
 VEKT8dr3599fnfPEM8OOXppBH35oaJ7taDp/3XurfpYJ5L/NjR
 LmCigFJqj/QKHEW7SGUX1BO2xW5SwGW643/K+1DoeJR1qnAzwr
 9JOLy0km/4uaSxgY7mkKgqJGJCFNrbg3p76icCAhSwNLdO4x3e
 fw0OB/5ObdVHK3RYmIhs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 February 2012, Eric Andersson wrote:
> This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
> generation of pressure sensors called BMP18x. These pressure sensors can be
> connected on I2C but also on SPI as a variant, so the driver implements both.
> Register-wise they are fully compatible with the older BMP085, so the driver will
> support those chips as well.
> 
> The driver is based on bmp085.c by Christoph Mair.

Hmm,  the implementation looks fine, but I don't think we should add support
for new devices with a one-off interface that we know is getting replaced by
something generic.

Why is this not using IIO for its user interface?

	Arnd
