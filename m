Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935442Ab1IOX2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:28:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52150 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab1IOX2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:28:11 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 00/13] wlags49_h2: Various cleanups
Date: Fri, 16 Sep 2011 00:20:44 +0100
Message-Id: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do some cleanup to try make it clearer what is actually done in the
configuration for HII and HII.5. Concentrate on hcf.c, which is where
most of the interesting logic is.

Verified be recompiling and confirming there are no changes to the
binary (except line offsets from calls to mdd_assert).

Patches are against v3.0

I made the bulk of these changes a while back, to see if I could
figure out what an orinoco based driver would need to do. Interest
petered out, so I've simply rebased and build checked in case this
helps anyone.

David Kilroy (13):
  staging: wlags49_h2: Remove non-linux configurations
  staging: wlags49_h2: Reindent hcfdef.h
  staging: wlags49_h2: Fix macro termination
  staging: wlags49_h2: Reindent hcf.c
  staging: wlags49_h2: Remove HCF_DL_ONLY
  staging: wlags49_h2: Simplify HCF_ENCAP usage
  staging: wlags49_h2: Remove some unused defines
  staging: wlags49_h2: Remove references to SSN
  staging: wlags49_h2: Remove MUL/DIV_BY_2
  staging: wlags49_h2: Remove CKIP support from hcf
  staging: wlags49_h2: Remove HCF_EXT_MB from code.
  staging: wlags49_h2: Reformat TX_CNTL comment
  staging: wlags49_h2: Remove continuous tx test

 drivers/staging/wlags49_h2/hcf.c    | 6434 +++++++++++++++++------------------
 drivers/staging/wlags49_h2/hcf.h    |   10 -
 drivers/staging/wlags49_h2/hcfcfg.h | 1567 ---------
 drivers/staging/wlags49_h2/hcfdef.h |  857 +++---
 drivers/staging/wlags49_h2/mdd.h    |   34 +-
 5 files changed, 3568 insertions(+), 5334 deletions(-)

-- 
1.7.4.1

