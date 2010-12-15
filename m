Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407Ab0LOA5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:57:07 -0500
Received: from tomasu.net ([64.85.170.234]:60548 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760387Ab0LOA5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:57:05 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Wake On lan and ATL1 nic
Date: Tue, 14 Dec 2010 17:56:59 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36.1+; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141756.59591.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't seem to get wol to work with my desktop, which has an integrated ATL1 
GbE nic. I can't be absolutely sure if it ever worked, but I think it did at 
one point. I can use ethtool to look at the wol status, that it supports 
magic-packet wol, and I can enable it, which is done at boot using an init 
script. But No matter how many times I try to send a wol packet to that 
machine it never wakes up.

Looking around on the net seems to say it is supported, and should work, but 
I'm not having any luck. Anyone have any hints?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
