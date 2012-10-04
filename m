Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab2JDHPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:15:10 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37336 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2JDHPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:15:08 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 83.155.44.161
Message-ID: <1349334903.3245.2.camel@novo.hadess.net>
Subject: Audio CD unusable in SATA Blu-ray drive
From: Bastien Nocera <hadess@hadess.net>
To: linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2012 09:15:03 +0200
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

I haven't been able to get an Audio CD to work in the 2 odd years that
I've used this machine. It has a builtin SATA Blu-ray drive that you
would think is able to play Audio CDs. But instead it keeps on trying to
reset the SATA link, and fails to do anything useful:

Oct  4 09:10:18 novo kernel: [  236.478076] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Oct  4 09:10:18 novo kernel: [  236.478084] sr 1:0:0:0: [sr0] CDB: 
Oct  4 09:10:18 novo kernel: [  236.478085] Read TOC/PMA/ATIP: 43 02 05 00 00 00 00 00 04 00 00 00
Oct  4 09:10:18 novo kernel: [  236.478097] ata2.00: cmd a0/00:00:00:04:00/00:00:00:00:00/a0 tag 0 pio 16388 in
Oct  4 09:10:18 novo kernel: [  236.478097]          res 40/00:02:00:00:02/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct  4 09:10:18 novo kernel: [  236.478100] ata2.00: status: { DRDY }
Oct  4 09:10:18 novo kernel: [  236.478105] ata2: hard resetting link
Oct  4 09:10:18 novo kernel: [  236.785657] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct  4 09:10:18 novo kernel: [  236.788020] ata2.00: configured for UDMA/100
Oct  4 09:10:20 novo kernel: [  238.554092] ata2: EH complete

Using Fedora 18's 3.6.0 kernel (3.6.0-3.fc18.x86_64)

My downstream bug report for reference:
https://bugzilla.redhat.com/show_bug.cgi?id=714714

Any ideas?

