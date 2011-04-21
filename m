Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1DUTSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:18:55 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:39560
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752542Ab1DUTSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:18:54 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: haiyangz <haiyangz@hz-dev.msft.interop.novell.com>
Subject: [PATCH 0/8] staging: hv: clean up forward declarations and camel cases in netvsc.c
Date: Thu, 21 Apr 2011 12:30:39 -0700
Message-Id: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: haiyangz <haiyangz@hz-dev.msft.interop.novell.com>

This patch series cleans up forward declarations and the
remaining camel cases in netvsc.c

Haiyang Zhang (8):
  staging: hv: move netvsc_initialize() to clean up forward declaration
  staging: hv: move netvsc_receive_completion() to clean up forward
    declaration
  staging: hv: move netvsc_send_recv_completion() to clean up forward
    declaration
  staging: hv: move netvsc_destroy_recv_buf() to clean up forward
    declaration
  staging: hv: move netvsc_destroy_send_buf() to clean up forward
    declaration
  staging: hv: move netvsc_device_add() to clean up forward declaration
  staging: hv: clean up unused forward declarations
  staging: hv: convert function name NetVscDisconnectFromVsp to lower
    case

 drivers/staging/hv/netvsc.c |  686 +++++++++++++++++++++----------------------
 1 files changed, 328 insertions(+), 358 deletions(-)

