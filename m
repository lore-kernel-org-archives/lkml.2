Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab2ANSdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:33:44 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59509 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab2ANSdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:33:43 -0500
MIME-Version: 1.0
Date: Sat, 14 Jan 2012 19:33:42 +0100
Message-ID: <CAC9WiBgRDEf_-F4qk+0TD83Gpaw2BxGD+UyaX8aQNuGUCWGVBw@mail.gmail.com>
Subject: 3.2.1 unable to use my cd/dvd drive
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm not sure that's related to the upgrade to 3.2.1 (actually I don't
think so) but I'm unable to burn some DVD rw now.

I tried several DVDs but failing each time with:

[17418.653910] end_request: I/O error, dev sr0, sector 0
[17418.654664] sr 1:0:0:0: [sr0] Unhandled sense code
[17418.654669] sr 1:0:0:0: [sr0]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[17418.654673] sr 1:0:0:0: [sr0]  Sense Key : Medium Error [current]
[17418.654679] sr 1:0:0:0: [sr0]  Add. Sense: Unable to recover
table-of-contents
[17418.654686] sr 1:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 04 00 00 00 02 00
[17418.654697] end_request: I/O error, dev sr0, sector 4096

Related drivers I'm using: sg, sr_mod, libata, sd_mod, scsi_mod

Could anybody tell me what's going on ?

Thanks
-- 
Francis
