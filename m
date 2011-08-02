Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1HBURa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:17:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51516 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab1HBUR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:17:26 -0400
Message-ID: <4E385B53.3040108@zytor.com>
Date: Tue, 02 Aug 2011 13:17:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Jin Park <jinyoungp@nvidia.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: aat2870 causes build failure in current upstream
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing an "allmodconfig" on i386:

drivers/built-in.o: In function `aat2870_bl_remove':
/home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:217:
undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `aat2870_bl_probe':
/home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:159:
undefined reference to `backlight_device_register'
/home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:201:
undefined reference to `backlight_device_unregister'
make[2]: *** [.tmp_vmlinux1] Error 1
make[1]: *** [sub-make] Error 2
make[1]: Leaving directory `/home/hpa/kernel/git.test'

	-hpa
