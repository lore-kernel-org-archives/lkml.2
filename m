Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321Ab2JYUyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:54:16 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59027
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab2JYUyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:54:15 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 0/2] Tools: hv: kvp_daemon
Date: Thu, 25 Oct 2012 14:15:14 -0700
Message-Id: <1351199714-25770-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes KVP implementation track the implementation
on Windows guests with regards to how IP addresses are returned.
Additionally, we  also returns more information for the
OSBuild key. 


K. Y. Srinivasan (2):
  tools: hv: Return the full kernel version
  Tools: hv: Don't return loopback addresses

 tools/hv/hv_kvp_daemon.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

-- 
1.7.4.1

