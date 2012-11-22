Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2KVTIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:08:10 -0500
Received: from dupo.coraid.com ([208.71.232.133]:48955 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756324Ab2KVTIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:08:04 -0500
Message-Id: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 0/8] aoe: miscellaneous fixes follow-up recent patch submissions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 19:52:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series applies to today's linux-next/akpm, commit
d3faae60d84f586ff8937b77c8476bca1b5f8ec6.

Ed L. Cashin (8):
  aoe: copy fallback timing information on destination failover
  aoe: remove vestigial request queue allocation
  aoe: increase default cap on outstanding AoE commands in the network
  aoe: cleanup: correct comment for aoetgt nout
  aoe: remove call to request handler from I/O completion
  aoe: make error messages more specific in static minor allocation
  aoe: initialize sysminor to avoid compiler warning
  aoe: return real minor number for static minors

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |   17 ++++-------------
 drivers/block/aoe/aoecmd.c |    5 ++---
 drivers/block/aoe/aoedev.c |   35 ++++++++++++++++++++++-------------
 4 files changed, 29 insertions(+), 30 deletions(-)

