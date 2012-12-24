Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2LXKpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 05:45:25 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:35199 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2LXKpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 05:45:23 -0500
MIME-Version: 1.0
In-Reply-To: <1356345665-8177-1-git-send-email-ldewangan@nvidia.com>
References: <1356345665-8177-1-git-send-email-ldewangan@nvidia.com>
Date: Mon, 24 Dec 2012 16:15:22 +0530
Message-ID: <CAHdPZaNk=SuzWTd8z+EJqeAEq4R7nGo=2C87T1NHWdTatP-=pw@mail.gmail.com>
Subject: Re: [PATCH V2] rtc: add RTC driver for TPS80031/TPS80032
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linuxfoundation.org, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 4:11 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Add an RTC driver for TPS80031/TPS80032 chips by TI.
> This driver supports:
> - Setting and getting time and date.
> - Setting and reading alarm time.
> - Alarm and interrupt functionlity.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - remvoe the checks for alarm time whether this is past or not in set_alarm.
> - add error prints if rtc registration failed.
> - add include of pm.h
>
>  drivers/rtc/Kconfig        |    8 +
>  drivers/rtc/Makefile       |    1 +
>  drivers/rtc/rtc-tps80031.c |  349 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 358 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-tps80031.c
>

Thanks for taking care of the comments !
