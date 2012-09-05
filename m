Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2IEQoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:44:20 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:52935
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751505Ab2IEQoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:44:18 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/4] Tools: hv 
Date: Wed,  5 Sep 2012 10:01:59 -0700
Message-Id: <1346864519-30020-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset was authored by Ben Hutchings <ben@decadent.org.uk>. Ben
asked me to submit this patchset. This patchset cleans up the KVP daemon
code and fixes some bugs.


K. Y. Srinivasan (4):
  tools: hv: Fix file handle leak
  tools: hv: Fix exit() error code
  tools: hv: Check for read/write errors
  tools: hv: Parse /etc/os-release

 tools/hv/hv_kvp_daemon.c |   95 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 78 insertions(+), 17 deletions(-)

-- 
1.7.4.1

