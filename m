Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab0GPGLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 02:11:07 -0400
Received: from troy.hostgo.com ([64.62.143.130]:45642 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758708Ab0GPGLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 02:11:04 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: mvsas still has problems with 2.6.34
Date: Fri, 16 Jul 2010 00:10:57 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.dmz.10-liquorix-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-scsi@vger.kernel.org, ayan@marvell.com, andy yan <andyysj@gmail.com>,
        "linux-raid" <linux-raid@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007160010.58000.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently updated my server, and the mvsas driver included in 2.6.34.1 
still causes my AOC-SASLP-MV8 card to completely lock up after mdraid starts 
up on the devices. The machine is essentially in "production" so I can't do 
a heck of a lot of testing on it anymore. The mvsas driver I got from Andy 
Yan seems to be a little outdated, it fails to compile due to a missing 
argument to sas_change_queue_depth, which I managed to fix, and I will try 
testing. I hope it works.

At some point though I really hope this gets fixed. I'm still willing to help 
test any new versions, just that I can't keep my box down for an extended 
period.

Thanks.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
