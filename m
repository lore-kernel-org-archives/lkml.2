Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab2DJDDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2DJDDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:03:07 -0400
Subject: [PATCH 0/2] adding tracepoints to vhost
To: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 10 Apr 2012 10:58:10 +0800
Message-ID: <20120410025327.49693.93562.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help in vhost analyzing, the following series adding basic tracepoints to
vhost. Operations of both virtqueues and vhost works were traced in current
implementation, net code were untouched. A top-like satistics displaying script
were introduced to help the troubleshooting.

TODO:
- net specific tracepoints?

---

Jason Wang (2):
      vhost: basic tracepoints
      tools: virtio: add a top-like utility for displaying vhost satistics


 drivers/vhost/trace.h   |  153 ++++++++++++++++++++
 drivers/vhost/vhost.c   |   17 ++
 tools/virtio/vhost_stat |  360 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 528 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vhost/trace.h
 create mode 100755 tools/virtio/vhost_stat

-- 
Jason Wang
