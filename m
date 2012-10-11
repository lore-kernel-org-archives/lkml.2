Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2JKPYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:24:50 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63159 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2JKPYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 11 Oct 2012 17:24:25 +0200
Message-ID: <CAH9NwWe+s1p73Jwa=s5aY_KjGS2nvP8LR2YH3i5gtpFMUYMiuw@mail.gmail.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/11 Lee Jones <lee.jones@linaro.org>:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
>
> The overhead is very low and the results will be found under
> sysfs/bootime, as well as detailed results in debugfs under
> boottime/. The bootgraph* files are compatible with
> scripts/bootgraph.pl. The reason for this patch is to provide
> data (sysfs/boottime) suitable for automatic testcases as
> well as help for developers to reduce the boot time (debugfs).
>

Nice idea... what about x86?
---
Christian Gmeiner, MSc
