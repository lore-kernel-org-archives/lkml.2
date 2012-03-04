Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2CDXJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 18:09:15 -0500
Received: from mail2.unitix.de ([176.9.2.175]:35704 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab2CDXJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 18:09:14 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2012 18:09:13 EST
Message-ID: <4F53F430.3000306@arndnet.de>
Date: Mon, 05 Mar 2012 00:01:04 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120302 Thunderbird/11.0
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: 3.3.0-rc6: iwlwifi: "Queue 2 stuck for 2000 ms" and "enqueue_hcmd
 failed"
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with -rc6 I'm experiencing repeated "Queue stuck" and "enqueue_hcmd failed" with my iwlwifi card (see below)
I had to remove the iwlwifi module to get rid of the "enqueue_hcmd failed" messages.

[   12.210568] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   12.210571] Copyright(c) 2003-2011 Intel Corporation
[   12.210720] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[   12.210723] iwlwifi 0000:03:00.0: pci_resource_base = ffffc900117b8000
[   12.210725] iwlwifi 0000:03:00.0: HW Revision ID = 0x35
[   12.210962] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
[   12.211039] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   12.211041] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[   12.211043] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   12.211045] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[   12.211047] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[   12.211095] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[   12.211209] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   12.227718] iwlwifi 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
[   12.227721] iwlwifi 0000:03:00.0: Device SKU: 0x1F0
[   12.227722] iwlwifi 0000:03:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
[   12.238076] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
...
[14342.041606] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[14342.050564] wlan0: moving STA 30:46:9a:XX:XX:XX to state 3
[14352.156223] wlan0: no IPv6 routers present
[16292.396276] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16292.396283] iwlwifi 0000:03:00.0: Current SW read_ptr 204 write_ptr 213
[16292.396339] iwlwifi 0000:03:00.0: Current HW read_ptr 204 write_ptr 213
[16292.396344] iwlwifi 0000:03:00.0: On demand firmware reload
[16292.396839] ieee80211 phy0: Hardware restart was requested
[16292.396922] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[16292.397115] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[16299.450565] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16299.450573] iwlwifi 0000:03:00.0: Current SW read_ptr 14 write_ptr 22
[16299.450630] iwlwifi 0000:03:00.0: Current HW read_ptr 14 write_ptr 22
[16299.450634] iwlwifi 0000:03:00.0: On demand firmware reload
[16299.451056] ieee80211 phy0: Hardware restart was requested
[16299.451143] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[16299.451337] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[16308.994632] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16308.994640] iwlwifi 0000:03:00.0: Current SW read_ptr 65 write_ptr 95
[16308.994695] iwlwifi 0000:03:00.0: Current HW read_ptr 65 write_ptr 95
[16308.994699] iwlwifi 0000:03:00.0: On demand firmware reload
[16308.995118] ieee80211 phy0: Hardware restart was requested
[16308.995189] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[16308.995378] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[16309.561199] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16309.561207] iwlwifi 0000:03:00.0: Current SW read_ptr 0 write_ptr 4
[16309.561262] iwlwifi 0000:03:00.0: Current HW read_ptr 0 write_ptr 4
[16323.526185] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16323.526192] iwlwifi 0000:03:00.0: Current SW read_ptr 81 write_ptr 119
[16323.526247] iwlwifi 0000:03:00.0: Current HW read_ptr 81 write_ptr 119
[16323.526252] iwlwifi 0000:03:00.0: On demand firmware reload
[16323.526707] ieee80211 phy0: Hardware restart was requested
[16323.526783] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[16323.526986] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[16324.096768] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16324.096775] iwlwifi 0000:03:00.0: Current SW read_ptr 0 write_ptr 1
[16324.096831] iwlwifi 0000:03:00.0: Current HW read_ptr 0 write_ptr 1
[16335.567967] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16335.567972] iwlwifi 0000:03:00.0: Current SW read_ptr 31 write_ptr 41
[16335.568049] iwlwifi 0000:03:00.0: Current HW read_ptr 31 write_ptr 41
[16335.568053] iwlwifi 0000:03:00.0: On demand firmware reload
[16335.568454] ieee80211 phy0: Hardware restart was requested
[16335.568527] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[16335.568693] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[16342.618309] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[16342.618317] iwlwifi 0000:03:00.0: Current SW read_ptr 35 write_ptr 48
[16342.618372] iwlwifi 0000:03:00.0: Current HW read_ptr 35 write_ptr 48
[16342.618376] iwlwifi 0000:03:00.0: On demand firmware reload
[16342.618790] ieee80211 phy0: Hardware restart was requested
[16342.618877] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[16342.619070] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[16662.384180] iwlwifi 0000:03:00.0: Queue 11 stuck for 2000 ms.
[16662.384188] iwlwifi 0000:03:00.0: Current SW read_ptr 165 write_ptr 172
[16662.384242] iwlwifi 0000:03:00.0: Current HW read_ptr 165 write_ptr 172
[16662.384246] iwlwifi 0000:03:00.0: On demand firmware reload
[16662.384665] ieee80211 phy0: Hardware restart was requested
[16662.384743] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[16662.384940] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[16662.976297] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16662.976305] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.074475] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.074484] iwlwifi 0000:03:00.0: I iwl_send_cmd_async Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
[16663.180640] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.180649] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.282728] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.282736] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.337814] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.337823] iwlwifi 0000:03:00.0: I iwl_send_cmd_async Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
[16663.409638] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.409649] iwlwifi 0000:03:00.0: I iwl_send_cmd_async Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
[16663.487797] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.487806] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.581202] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.581212] iwlwifi 0000:03:00.0: I iwl_send_cmd_async Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
[16663.589332] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.589337] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.691289] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.691299] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.793427] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.793436] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.896341] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.896369] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16663.916362] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.916371] iwlwifi 0000:03:00.0: I iwl_send_cmd_async Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
[16663.997737] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16663.997747] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16664.099898] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16664.099907] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16664.201956] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16664.201965] iwlwifi 0000:03:00.0: U iwl_send_cmd_async Error sending SENSITIVITY_CMD: enqueue_hcmd failed: -5
[16664.251524] iwlwifi 0000:03:00.0: Not sending command - CT KILL
[16664.251535] iwlwifi 0000:03:00.0: I iwl_send_cmd_async Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
[16664.304247] iwlwifi 0000:03:00.0: Not sending command - CT KILL
