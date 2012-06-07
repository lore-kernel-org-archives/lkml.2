Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785Ab2FGNko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:40:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34039 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2FGNkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:40:43 -0400
MIME-Version: 1.0
Reply-To: rus@sfinxsoft.com
In-Reply-To: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
From: Rus <rus@sfinxsoft.com>
Date: Thu, 7 Jun 2012 16:40:01 +0300
X-Google-Sender-Auth: iynnNfeCYCxINfZucPkEszkI6Ps
Message-ID: <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
Subject: 3.[34].x Reproducable [Firmware bug] message upon warm boot only
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have the following reproducable message upon each 3.4.1 warm boot :

....
[Firmware Bug]: cpu 0, invalid threshold interrupt offset 0 for bank
4, block 0 (MSR00000413=0xc010000001000000)
[Firmware Bug]: cpu 0, invalid threshold interrupt offset 0 for bank
4, block 1 (MSRC0000408=0xc010000001000000)
[Firmware Bug]: cpu 0, invalid threshold interrupt offset 0 for bank
4, block 2 (MSRC0000409=0xc01001c001000000)
.....
[Firmware Bug]: cpu 7, try to use APIC500 (LVT offset 0) for vector
0x10400, but the register is already in use for vector 0xf9 on another
cpu
[Firmware Bug]: cpu 7, IBS interrupt offset 0 not available
(MSRC001103A=0x0000000000000100)
Failed to setup IBS, -22
.....

Cold boot do not show this message. The hardware is Asus M5A97 PRO
(latest 1208 Bios) and FX-8150 CPU, 24GB RAM, the only system on this
box is Linux.

Is this message harmless or this is some problem with hardware/bios/Linux ?

Can supply any additional info.

TIA, Rus

--
SfinxSoft
http://sfinxsoft.com
