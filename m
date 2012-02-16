Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab2BPP1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:27:16 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52161 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2BPP1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:27:15 -0500
MIME-Version: 1.0
In-Reply-To: <1329403520-32551-1-git-send-email-danny.kukawka@bisect.de>
References: <1329403520-32551-1-git-send-email-danny.kukawka@bisect.de>
Date: Thu, 16 Feb 2012 23:27:14 +0800
Message-ID: <CAN1soZyGoVA8A1BKyh73EHDxoR-St8g9eM1QOWLqp1+H2r0dXw@mail.gmail.com>
Subject: Re: [PATCH] arch/arm/mach-mmp/: some files include some headers twice
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, Danny Kukawka <dkukawka@suse.de>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 10:45 PM, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> arch/arm/mach-mmp/: some files include some headers twice:
> - arch/arm/mach-mmp/aspenite.c and
>  arch/arm/mach-mmp/tavorevb.c: 'linux/gpio.h'
> - arch/arm/mach-mmp/pxa168.c: 'linux/platform_device.h'
>
> Remove the duplicates.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied. Thanks
