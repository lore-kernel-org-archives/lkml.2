Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2KYMWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 07:22:21 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:38290 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab2KYMWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 07:22:20 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: pxa: pxa27x.c: add dummy SA1100 rtc clock
References: <1353712328-15830-1-git-send-email-andrea.adami@gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 25 Nov 2012 13:21:52 +0100
In-Reply-To: <1353712328-15830-1-git-send-email-andrea.adami@gmail.com>
	(Andrea Adami's message of "Sat, 24 Nov 2012 00:12:08 +0100")
Message-ID: <87ehjh3man.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Adami <andrea.adami@gmail.com> writes:
> * Using pxa27x you could now build both RTC_DRV_PXA and RTC_DRV_SA1100.
> * Make sure you don't use both together: link /dev/rtc0 or /dev/rtc1
> * to /dev/rtc according to your requirement.
Weird to have stars at the beginning of each line in the patch description.
But anyway :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

-- 
Robert
