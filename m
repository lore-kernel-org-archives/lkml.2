Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab2IEVTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:19:14 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34395
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759440Ab2IEVTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:19:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] Tools: hv 
Date: Wed,  5 Sep 2012 14:37:00 -0700
Message-Id: <1346881020-31440-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes some bugs in the KVP daemon code.

Ben Hutchings (3):
  tools/hv: Fix file handle leak
  tools/hv: Fix exit() error code
  tools/hv: Check for read/write errors

 tools/hv/hv_kvp_daemon.c |   45 +++++++++++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 14 deletions(-)

-- 
1.7.4.1

