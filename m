Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2LDBjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:39:06 -0500
Received: from dupo.coraid.com ([208.71.232.133]:40621 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211Ab2LDBjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:39:05 -0500
Subject: [PATCH 0/7] aoe: driver improvements and fixes through v81
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Mon, 3 Dec 2012 20:38:55 -0500
Message-ID: <3183cff4071d83972c722ad3655209d5@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series applies to today's linux-next/akpm, commit
a5944abc848a1b8e5329a631a84e35a3b0249ecb.

Ed L. Cashin (7):
  aoe: improve handling of misbehaving network paths
  aoe: avoid races between device destruction and discovery
  aoe: use dynamic number of remote ports for AoE storage target
  aoe: allow user to disable target failure timeout
  aoe: allow comma separator in aoe_iflist value
  aoe: identify source of runt AoE packets
  aoe: update internal version number to 81

 Documentation/aoe/aoe.txt  |    4 +-
 drivers/block/aoe/aoe.h    |   29 ++-
 drivers/block/aoe/aoeblk.c |   38 ++++-
 drivers/block/aoe/aoecmd.c |  439 ++++++++++++++++++++++++++++++--------------
 drivers/block/aoe/aoedev.c |  177 ++++++++++++------
 drivers/block/aoe/aoenet.c |    2 +-
 6 files changed, 477 insertions(+), 212 deletions(-)

