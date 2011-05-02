Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab1EBVko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:40:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab1EBVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:37:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
Date: Mon, 2 May 2011 23:36:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: johnlinn@comcast.net, nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, john.linn@xilinx.com
References: <538266033.2230575.1304371624720.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <538266033.2230575.1304371624720.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105022336.52663.arnd@arndb.de>
X-Provags-ID: V02:K0:/PlYifJc7wXShyM3DDzjiyNXlTPRJvm1vKthxk3vpSE
 coZWiedMzhXZmOhHng7H/RZDoM51+uZNMq76VHqYs4d83sbTjd
 L1L2yiN3aIRVPJg5nusHAZwPJ6mXYhg5vMZi7wEUvX/lSybOhP
 vASbKARuAsNVOiqZKeF2GgxJ5ExCFpFW5fuZVhIW1OWnmKMPa4
 gLyq0iJDJIH5pLI0opNqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 May 2011 23:27:04 johnlinn@comcast.net wrote:
> Yes we could explain hard coded numbers.  Ideally GIC driver would support
> device tree it seems like to me.

> 
> Seems like the GIC driver could remap it's own memory but maybe that won't
> work across all platforms and then the platform would need to do it.

Why not just add a stub in the xilinx platform for now that remaps the
memory using ioremap and calls the regular GIC initialization?

That function can then easily be moved to common code when another
platform uses it.

	Arnd
