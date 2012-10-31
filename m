Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2JaKNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:13:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33861 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754205Ab2JaKNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:13:21 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] checkpatch: Add support for decimal values
Date: Wed, 31 Oct 2012 03:13:10 -0700
Message-Id: <cover.1351578285.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel doesn't use decimals though.

Joe Perches (3):
  checkpatch: Find hex constants as a single IDENT
  checkpatch: Add support for decimal constants
  checkpatch: Emit a warning when decimal values are used

 scripts/checkpatch.pl |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

-- 
1.7.8.112.g3fd21

