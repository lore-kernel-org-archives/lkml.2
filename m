Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0HVIAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 04:00:31 -0400
Received: from [64.85.170.234] ([64.85.170.234]:42046 "EHLO mail.tomasu.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab0HVIA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 04:00:28 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k problem with 2.6.35
Date: Sun, 22 Aug 2010 01:53:41 -0600
User-Agent: KMail/1.13.5 (Linux/2.6.35-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201008220005.38969.tfjellstrom@strangesoft.net>
In-Reply-To: <201008220005.38969.tfjellstrom@strangesoft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008220153.41678.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On August 22, 2010, Thomas Fjellstrom wrote:
> Hi, I'm running 2.6.35, and my wireless card fails to initialize properly
> on boot. I get the following messages in dmesg:

Probably important, but I missed a couple lines:
 
> [    0.866525] ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
> 17 [    0.866536] ath5k 0000:02:00.0: setting latency timer to 64
> [    0.866571] ath5k 0000:02:00.0: registered as 'phy0'
> [    1.358241] ath: EEPROM regdomain: 0x67
> [    1.358242] ath: EEPROM indicates we should expect a direct regpair map
> [    1.358245] ath: Country alpha2 being used: 00
> [    1.358247] ath: Regpair used: 0x67
   [    1.360589] phy0: Failed to initialize wep: -2
> [    1.372021] ath5k phy0: can't register ieee80211 hw
> [    1.372080] ath5k 0000:02:00.0: PCI INT A disabled
> [    1.372084] ath5k: probe of 0000:02:00.0 failed with error -2
>
> That said, if I remove the ath5k module, and modprobe ath5k, it starts
> working.
> 
> [ 2976.411770] ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
> 17 [ 2976.411783] ath5k 0000:02:00.0: setting latency timer to 64
> [ 2976.412767] ath5k 0000:02:00.0: registered as 'phy1'
> [ 2976.912422] ath: EEPROM regdomain: 0x67
> [ 2976.912424] ath: EEPROM indicates we should expect a direct regpair map
> [ 2976.912427] ath: Country alpha2 being used: 00
> [ 2976.912429] ath: Regpair used: 0x67
   [ 2977.078747] phy1: Selected rate control algorithm 'minstrel'
> [ 2977.079190] ath5k phy1: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
> 
> Is this a known issue?

Thanks

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
