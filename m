Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1KOQJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:09:24 -0500
Received: from mail-dy0-f46.google.com ([209.85.220.46]:57748 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1KOQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:09:23 -0500
MIME-Version: 1.0
In-Reply-To: <1321356224-5053-1-git-send-email-sangwook.lee@linaro.org>
References: <1321356224-5053-1-git-send-email-sangwook.lee@linaro.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 15 Nov 2011 08:09:00 -0800
X-Google-Sender-Auth: pXTmV_OWmm-lSEEqIjVelUdRWvY
Message-ID: <CAB=NE6UB6KzJ2p+sou4wcgnZ9jyQxhpWMr2qZ2=jwqaGc2L5Xw@mail.gmail.com>
Subject: Re: [PATCH] ath9k: rename ath9k_platform.h to ath_platform.h
To: Sangwook Lee <sangwook.lee@linaro.org>, Gabor Juhos <juhosg@openwrt.org>,
        Imre Kaloz <kaloz@openwrt.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        ralf@linux-mips.org, linville@tuxdriver.com, rmanohar@qca.qualcomm.com,
        patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 3:23 AM, Sangwook Lee <sangwook.lee@linaro.org> wrote:
> The patch series proposes to rename ath9k_platform.h to "ath_platform.h
> This header file handles platform data used only for ath9k,
> but it can used by ath6k as well.

Adding the actual OpenWrt stakeholders. Is there any public hardware
platform that uses this yet?

  Luis
