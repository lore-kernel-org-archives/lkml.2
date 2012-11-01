Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2KAHKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:10:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55171 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753329Ab2KAHKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:10:53 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/3] checkpatch: Add support for floating point constants
Date: Thu,  1 Nov 2012 00:10:38 -0700
Message-Id: <cover.1351736873.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel doesn't support them though.

v2: Make it clearer that checkpatch understands floating point constants
    Support floating point hex constants too

Joe Perches (3):
  checkpatch: Find hex constants as a single IDENT
  checkpatch: Add support for floating point constants
  checkpatch: Emit an warning when floating point values are used

 scripts/checkpatch.pl |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

-- 
1.7.8.112.g3fd21

