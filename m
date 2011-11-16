Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1KPVLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:11:54 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:44870 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1KPVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:11:53 -0500
X-Spam-Flag: NO
X-Spam-Score: -3.138
Message-ID: <4EC42717.2050806@openwrt.org>
Date: Wed, 16 Nov 2011 22:11:51 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: Sangwook Lee <sangwook.lee@linaro.org>, Imre Kaloz <kaloz@openwrt.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        ralf@linux-mips.org, linville@tuxdriver.com, rmanohar@qca.qualcomm.com,
        patches@linaro.org
Subject: Re: [PATCH] ath9k: rename ath9k_platform.h to ath_platform.h
References: <1321356224-5053-1-git-send-email-sangwook.lee@linaro.org> <CAB=NE6UB6KzJ2p+sou4wcgnZ9jyQxhpWMr2qZ2=jwqaGc2L5Xw@mail.gmail.com>
In-Reply-To: <CAB=NE6UB6KzJ2p+sou4wcgnZ9jyQxhpWMr2qZ2=jwqaGc2L5Xw@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011.11.15. 17:09 keltezéssel, Luis R. Rodriguez írta:
> On Tue, Nov 15, 2011 at 3:23 AM, Sangwook Lee <sangwook.lee@linaro.org> wrote:
>> The patch series proposes to rename ath9k_platform.h to "ath_platform.h
>> This header file handles platform data used only for ath9k,
>> but it can used by ath6k as well.
> 
> Adding the actual OpenWrt stakeholders. Is there any public hardware
> platform that uses this yet?

It is used by the ath79 platform code in the mainline kernel, although only the
AP81 reference board uses that for now. However the linux-mips tree also has
code for the AP121 reference board, and that will use it as well.

Additionaly, we are using that in OpenWrt for several consumer boards which are
based on the AR71xx/AR724x/AR913x SoCs.

-Gabor
