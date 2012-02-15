Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2BOQyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:54:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:31128 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab2BOQys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:54:48 -0500
Subject: [PATCH 0/2] IPC: message queue checkpoint support
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com
Date: Wed, 15 Feb 2012 20:54:23 +0400
Message-ID: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set conatins v2 of patch
"IPC: message queue stealing feature introduced"

The following series consists of:

---

Stanislav Kinsbursky (2):
      IPC: message queue receive cleanup
      IPC: message queue stealing feature introduced


 arch/tile/kernel/compat.c |   11 +-----
 include/linux/compat.h    |    2 +
 include/linux/msg.h       |   13 ++++++-
 ipc/compat.c              |   62 ++++++++++++++++++++++++--------
 ipc/msg.c                 |   86 +++++++++++++++++++++++++++++++++++----------
 5 files changed, 126 insertions(+), 48 deletions(-)

