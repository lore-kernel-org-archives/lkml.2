Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2KTSox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:44:53 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60432 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2KTSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:44:52 -0500
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:9582:8241:8278:2cf3]
In-Reply-To: <1353432158-22999-1-git-send-email-dianders@chromium.org>
References: <1353432158-22999-1-git-send-email-dianders@chromium.org>
Date: Tue, 20 Nov 2012 10:44:51 -0800
Message-ID: <CAOesGMjSP2nJYXccs7n_4u-RVcyhOniEA9nkayEH4GR8muj5ag@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: exynos: Move the dwmmc aliases from
 smdk5250 dts to exynos
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, Olof Johansson <olofj@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 9:22 AM, Doug Anderson <dianders@chromium.org> wrote:
> The aliases for dwmmc were placed in the SMDK5250 dts file but really
> should be common for all exynos5250 boards.  Move it to the common CPU
> file.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
