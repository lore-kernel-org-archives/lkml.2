Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1BYOMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:12:19 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:58395 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab1BYOMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:12:16 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, Rodolfo Giometti <giometti@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCH 0/2] fix two minor PPS issues
Date: Fri, 25 Feb 2011 17:11:54 +0300
Message-Id: <1298643116-3488-1-git-send-email-lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110208153129.0f7fe5d3.akpm@linux-foundation.org>
References: <20110208153129.0f7fe5d3.akpm@linux-foundation.org>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix two minor issues in PPS. The first is reported in
this thread and the second I found myself.

Alexander Gordeev (2):
  pps: initialize ts_real properly
  pps: remove unreachable code

 drivers/pps/generators/pps_gen_parport.c |    5 -----
 drivers/pps/kapi.c                       |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

-- 
1.7.2.3

