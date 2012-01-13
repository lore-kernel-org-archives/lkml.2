Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2AMSvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:51:53 -0500
Received: from mail.tomasu.net ([64.85.170.232]:58320 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab2AMSvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:51:51 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: mvsas with 3.1
Date: Fri, 13 Jan 2012 11:44:57 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        ayan@marvell.com, andy yan <andyysj@gmail.com>,
        "linux-raid" <linux-raid@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201131144.58044.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there chance this driver will ever be stable? After more than two years I'm 
starting to get extremely frustrated. I don't really have the option at the 
moment to get a new card, otherwise I would, likely a non marvell based 
device.

It actually managed to last 10 days this time though. Which is a record. The 
interesting thing is there are no warnings or errors in dmesg coming from the 
mvsas driver or scsi code. All that's happened is processes lock up when 
trying to write. Reading seems to be fine.

Just to refresh everyone's memory, it's a AOC-SASLP-MV8 card, has a 
MV64460/64461/64462 chipset. And I have 7 (seagate 7200.12 SATA drives hooked 
up).

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
