Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2DPOGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:06:04 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45346 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab2DPOGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:06:02 -0400
Subject: [PATCH v2 0/2] IPC: message queue checkpoint/restore -	requested
 updates
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, mtk.manpages@gmail.com
Date: Mon, 16 Apr 2012 18:05:56 +0400
Message-ID: <20120416140235.653.36996.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing to previous version:
1) single patch for all changes related to the feature (i.e. this patch is the
replacement for c-r-ipc-message-queue-stealing-feature-introduced.patch).
2) Added self-test for MSG_PEEK_ALL feature.

The following series consists of:

---

Stanislav Kinsbursky (2):
      IPC: message queue stealing feature introduced
      IPC: selftest tor new MSG_PEEK_ALL flag for msgrcv()


 include/linux/msg.h                           |    8 +
 ipc/compat.c                                  |   42 ++++++
 ipc/msg.c                                     |   65 +++++++++-
 tools/testing/selftests/ipc/Makefile          |   31 +++++
 tools/testing/selftests/ipc/msgque_peek_all.c |  170 +++++++++++++++++++++++++
 5 files changed, 313 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/ipc/Makefile
 create mode 100644 tools/testing/selftests/ipc/msgque_peek_all.c

