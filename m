Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab0JQGUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 02:20:55 -0400
Received: from mailhub.stratus.com ([134.111.1.17]:45572 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0JQGUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 02:20:54 -0400
From: Bandan Das <bandan.das@stratus.com>
To: David Miller <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>, NetDev <netdev@vger.kernel.org>,
        joe@perches.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Bandan Das <bandan.das@stratus.com>
Subject: [PATCH 0/2] bonding: checkpatch.pl cleanups in bond_3ad.c
Date: Sun, 17 Oct 2010 02:19:57 -0400
Message-Id: <1287296399-25142-1-git-send-email-bandan.das@stratus.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 17 Oct 2010 06:20:46.0347 (UTC) FILETIME=[6F4BA5B0:01CB6DC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some cleanups based on errors/warnings reported by checkpatch.pl.
There are still a ton of lines greater than 80 chars and I tried to fix 
a few that I came across.

Bandan Das (2):
  bonding: cleanup : add space around operators
  bonding: cleanup: remove braces from single block statements

 drivers/net/bonding/bond_3ad.c |  274 ++++++++++++++++++++--------------------
 1 files changed, 139 insertions(+), 135 deletions(-)

-- 
Bandan


