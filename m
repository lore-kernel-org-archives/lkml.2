Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab2CTOZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:25:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43142 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2CTOZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <07BBB2AAB1A10A488A2AD166C7CB8B0DF3EC27@nasanexd02b.na.qualcomm.com>
References: <Acz7Xq9MjsyGPasdTvauqG8msmvJ7AAGDXAg> <07BBB2AAB1A10A488A2AD166C7CB8B0DF3EC27@nasanexd02b.na.qualcomm.com>
From: Eric Miao <eric.miao@canonical.com>
Date: Tue, 20 Mar 2012 22:24:59 +0800
X-Google-Sender-Auth: SkU6xRhbE59xh-mZZrImuuS7OBA
Message-ID: <CAMPhdO8c1FvnfCUxUODE7U_tmydfd235JXhq=KOx=x5urX84eA@mail.gmail.com>
Subject: Re: [patch] ath3k-1.fw: Fix firmware issue
To: "Yao, Costa" <cqyao@qca.qualcomm.com>
Cc: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From 5b3d3920ab3991b6450e6cc106666c1e10547824 Mon Sep 17 00:00:00 2001
> From: Costa Yao <cqyao@qca.qualcomm.com>
> Date: Tue, 6 Mar 2012 13:56:24 +0800
> Subject: [PATCH] [patch]ath3k-1.fw: Fix firmware issue.
>
> Force the dangle to change the PID value after the downloading of ath3k-1.fw.
>
> Signed-off-by: Costa Yao <cqyao@qca.qualcomm.com>

Tested-by: Eric Miao <eric.miao@canonical.com>

With DW1702, AR3011 Bluetooth module. After using this firmware
blob, the AR3011 BT module changes its PID to 3005, and then
btusb.ko can be working all right.

Please refer to http://bugs.launchpad.net/bugs/714862 for details.


> ---
>  WHENCE     |    2 +-
>  ath3k-1.fw |  Bin 246804 -> 246804 bytes
>  2 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/WHENCE b/WHENCE
> index 01fa5ca..4cc9cbd 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1209,7 +1209,7 @@ Driver: ath3k - DFU Driver for Atheros bluetooth chipset AR3011
>  File: ath3k-1.fw
>  Info: v1.0
>
> -Fix EEPROM radio table issue and change PID to 3005
> +Fix firmware issue and force to change PID after downloading of ath3k-1.fw
>
>  Licence: Redistributable. See LICENCE.atheros_firmware for details
>
> diff --git a/ath3k-1.fw b/ath3k-1.fw
> index 63aa9b9ad87d3d918e441d921ada9cad08687ae5..0f6335030a8541db35894a00ea607ae945f31947 100644
> GIT binary patch
> delta 101591
> zcma%jd03Oj_VCP`g)A?Su!Jp05(xViP+Y2&AR;2Rpp~j!6f{(=tzvCmYOf@=ib`)u

..... [snipped]
