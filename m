Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab1KVLr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:47:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62081 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab1KVLrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:47:55 -0500
MIME-Version: 1.0
In-Reply-To: <4ECB65A5.3010009@arndnet.de>
References: <4EC6DE6B.3080603@arndnet.de>
	<4ECB65A5.3010009@arndnet.de>
Date: Tue, 22 Nov 2011 13:47:53 +0200
Message-ID: <CANUX_P1RXxRuybzj0gavVOkN-a3H_qRO45S1nc3oPq1aZe5V3g@mail.gmail.com>
Subject: Re: 3.2.0-rc2: WARNING: at iwlwifi/wl-trans-pcie.c:1105
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> additional to the WARNING wireless with iwlwifi seems to be very flaky on 3.2.0-rc2.
> Ping to the AP goes up to 4-5s in some periods (with network generally idle).
> Here is some more info about the Hardware:
>
> [   11.133719] iwlwifi 0000:03:00.0: HW Revision ID = 0x35
> [   11.133825] iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
> [   11.133865] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
> [   11.133931] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   11.150077] iwlwifi 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
> [   11.150081] iwlwifi 0000:03:00.0: Device SKU: 0X1f0
> [   11.150083] iwlwifi 0000:03:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
> [   11.150648] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [   11.417837] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532
>
> If you need some more info, please don't hesitate to ask.
>

Yeah I know about that one. I haven't found the time to look at it yet.
I do have a patch that can help to debug. This patch will be sent
through the regular channel.
I am considering to remove the warning though
