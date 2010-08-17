Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab0HQJ52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:57:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:60649 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0HQJ51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:57:27 -0400
Date: Tue, 17 Aug 2010 18:57:25 +0900 (JST)
Message-Id: <20100817.185725.260189930.ryusuke@osrg.net>
To: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.36-rc1 compile breakage in toshiba_acpi driver
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Aug 2010 18:57:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following error during compiling 2.6.36-rc1.

> ERROR: "led_classdev_register" [drivers/platform/x86/toshiba_acpi.ko] undefined!
> ERROR: "led_classdev_unregister" [drivers/platform/x86/toshiba_acpi.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Is anyone looking at this issue ?

Thanks,
Ryusuke Konishi
