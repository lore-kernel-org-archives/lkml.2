Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2JIUAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:00:10 -0400
Received: from mxout1.idt.com ([157.165.5.25]:33670 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2JIUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:00:07 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 0/3] rapidio: updates for multiple mport patches
Date: Tue,  9 Oct 2012 15:57:53 -0400
Message-Id: <1349812676-27057-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of updates for patches submitted earlier:
https://lkml.org/lkml/2012/10/3/460.

Alexandre Bounine (3):
  rapidio: use msleep in discovery wait
  rapidio: update asynchronous discovery initialization
  rapidio: update for destination ID allocation

 drivers/rapidio/rio-scan.c |   40 ++++++++++-------------
 drivers/rapidio/rio.c      |   75 +++++++++++++++++++++++++++----------------
 include/linux/rio.h        |    1 -
 3 files changed, 64 insertions(+), 52 deletions(-)

-- 
1.7.8.4

