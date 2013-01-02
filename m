Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3ABUbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:31:31 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:38076 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3ABUb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:31:28 -0500
MIME-Version: 1.0
X-Originating-IP: [95.200.223.160]
In-Reply-To: <1356921314-12595-2-git-send-email-tobetter@gmail.com>
References: <1356921314-12595-1-git-send-email-tobetter@gmail.com>
	<1356921314-12595-2-git-send-email-tobetter@gmail.com>
Date: Wed, 2 Jan 2013 12:31:27 -0800
Message-ID: <CAOesGMgoyT2xTwgPBw1CASO-6iakpRLxEh1aad-LL7SxJ1+5Vg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ODROID-X: dts: Add board dts file for ODROID-X
From: Olof Johansson <olof@lixom.net>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 6:35 PM, Dongjin Kim <tobetter@gmail.com> wrote:
> Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412 SoC.
>
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>

Patch 1-4:

Acked-by: Olof Johansson <olof@lixom.net>

... but I think it might make sense to just add the file as one commit
instead of splitting it across 4 as this series does.


-Olof
