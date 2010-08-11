Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0HKR2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:28:10 -0400
Received: from dell.nexicom.net ([216.168.96.13]:46457 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab0HKR2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:28:09 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 13:28:09 EDT
Message-ID: <4C62DB6E.5010001@lockie.ca>
Date: Wed, 11 Aug 2010 13:18:38 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100809 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel config
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 CONFIG_SATA_AHCI
│ This option enables support for AHCI Serial ATA. │
│ │
│ If unsure, say N.

CONFIG_ATA_SFF: │
│ │
│ This option adds support for ATA controllers with SFF │
│ compliant or similar programming interface. │
│ │
│ SFF is the legacy IDE interface that has been around since │
│ the dawn of time. Almost all PATA controllers have an │
│ SFF interface. Many SATA controllers have an SFF interface │
│ when configured into a legacy compatibility mode. │
│ │
│ For users with exclusively modern controllers like AHCI, │
│ Silicon Image 3124, or Marvell 6440, you may choose to │
│ disable this unneeded SFF support.


I recently configured and compiled the 2.6.35.1 kernel.
I suggest moving
│
│ For users with exclusively modern controllers like AHCI, │
│ Silicon Image 3124, or Marvell 6440, you may choose to │
│ disable this unneeded SFF support.
to the CONFIG_SATA_AHCI option.
