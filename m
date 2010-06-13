Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0FMP1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:27:18 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:59059 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0FMP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:27:16 -0400
From: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
To: legerde@gmail.com, linux-kernel@vger.kernel.org
Subject: Aerospace and linux
Date: Sun, 13 Jun 2010 18:26:58 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-home1; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Message-Id: <201006131826.58146.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Storage will probably be something really cheap.  So I assume flash.
>But, possibly a USB stick type device.   Maybe an IDE based solid
>state storage device.

Most of commercial controllers (USB and IDE) use intermediate cache/buffer 
memory, that will be vulnerable to byte flipping (as i know even SRAM 
vulnerable to that).	Some of them have their own firmware, storing somewhere 
chip wearing information, and if bit flipping happen there - they just will 
fail (common issue: USB flash not recognized anymore or have 0 bytes 
capacity).

	I guess you need truly embedded device, including PCB design, and operate 
with storage chips directly (RAM, flash chips). Also flash (NOR and NAND) 
vulnerable to bit-flipping too, and it is prefferable to use hardened IC's (i 
doubt there is hardened USB/IDE controllers), protected bus design, strong 
error recovery algo's, system and parts redundancy and etc.
