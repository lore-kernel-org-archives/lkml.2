Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1KVJEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:04:43 -0500
Received: from mail2.unitix.de ([176.9.2.175]:43429 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1KVJEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:04:38 -0500
Message-ID: <4ECB65A5.3010009@arndnet.de>
Date: Tue, 22 Nov 2011 10:04:37 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.2.0-rc2: WARNING: at iwlwifi/wl-trans-pcie.c:1105
References: <4EC6DE6B.3080603@arndnet.de>
In-Reply-To: <4EC6DE6B.3080603@arndnet.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

additional to the WARNING wireless with iwlwifi seems to be very flaky on 3.2.0-rc2.
Ping to the AP goes up to 4-5s in some periods (with network generally idle).
Here is some more info about the Hardware:

[   11.133719] iwlwifi 0000:03:00.0: HW Revision ID = 0x35
[   11.133825] iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
[   11.133865] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[   11.133931] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   11.150077] iwlwifi 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
[   11.150081] iwlwifi 0000:03:00.0: Device SKU: 0X1f0
[   11.150083] iwlwifi 0000:03:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[   11.150648] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   11.417837] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532

If you need some more info, please don't hesitate to ask.

Best regards
Arnd
