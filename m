Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2CTD1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:27:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45039 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2CTD1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:27:07 -0400
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 0/4] compat: March 19 backport work
Date: Mon, 19 Mar 2012 20:26:57 -0700
Message-Id: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

With the latest linux-next we get failures to build compat-wireless,
this addresses compilation down to 2.6.33. I could use help with tracing
backport for kernels <= 2.6.32, that is please try against 2.6.32, I hit
an issue there.

Review of this is greatly appreciated. I've already pushed this out as
at least I can verify this does not break compilation for older kernels.
Run time testing against older kernels for the system workqueue stuff
would be greatly appreciated as well.

Luis R. Rodriguez (4):
  compat: backport system work queues system_wq and system_long_wq
  compat: backport work_busy()
  compat: fix load time issue with kfifo backport
  compat: add some tracing backport work

 compat/compat-2.6.36.c        |   77 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/compat-2.6.28.h |    4 +++
 include/linux/compat-2.6.36.h |   40 +++++++++++++++++++++
 include/linux/tracepoint.h    |   40 +++++++++++++++++++++
 scripts/gen-compat-config.sh  |    2 +-
 5 files changed, 161 insertions(+), 2 deletions(-)

-- 
1.7.10.rc1.22.gf5241

