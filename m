Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237Ab2KBKvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:51:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43615 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab2KBKvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:51:05 -0400
Message-ID: <5093A592.9070605@ahsoftware.de>
Date: Fri, 02 Nov 2012 11:50:58 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: AMD A10: MCE Instruction Cache Error
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just got the following on an AMD A10 5800K:

------
[ 8395.999581] [Hardware Error]: CPU:0 
MC1_STATUS[-|CE|MiscV|-|AddrV|-|-]: 0x8c00002000010151
[ 8395.999586] [Hardware Error]:        MC1_ADDR: 0x0000ffffa00e1203
[ 8395.999588] [Hardware Error]: Instruction Cache Error: Parity error 
during data load from IC.
[ 8395.999590] [Hardware Error]: cache level: L1, tx: INSN, mem-tx: IRD
------

Kernel is 3.6.5, MB is an Asus F2A85-M with BIOS 5103 (the latest).

Can someone enlight me about what might be wrong with my (new) system 
(memtest didn't show an errors)?

What IC is meant? As far as I know, this processor doesn't support ECC, 
so I wonder where that parity error does come from.

Regards,

Alexander
