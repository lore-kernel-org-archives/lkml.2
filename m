Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2JMQrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:47:53 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:43479
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab2JMQrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:47:52 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Tools: hv: kvp_daemon
Date: Sat, 13 Oct 2012 10:08:05 -0700
Message-Id: <1350148085-16455-1-git-send-email-kys@microsoft.com>
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

