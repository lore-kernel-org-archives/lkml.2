Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0K1JFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 04:05:53 -0500
Received: from mail.perches.com ([173.55.12.10]:1885 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0K1JFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 04:05:49 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] drivers/net: Remove unnecessary [kv][mcz]alloc casts
Date: Sun, 28 Nov 2010 01:05:42 -0800
Message-Id: <cover.1290934782.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the last remaining alloc casts in drivers/net...

Joe Perches (4):
  netxen: remove unnecessary [kv][mcz]alloc casts
  qlcnic: remove unnecessary [kv][mcz]alloc casts
  vxge: remove unnecessary [kv][mcz]alloc casts
  zd1211rw: remove unnecessary [kv][mcz]alloc casts

 drivers/net/netxen/netxen_nic_init.c    |    3 +--
 drivers/net/qlcnic/qlcnic_init.c        |    3 +--
 drivers/net/vxge/vxge-config.c          |   24 +++++++++---------------
 drivers/net/vxge/vxge-main.c            |    4 +---
 drivers/net/wireless/zd1211rw/zd_chip.c |    3 +--
 5 files changed, 13 insertions(+), 24 deletions(-)

-- 
1.7.3.2.245.g03276.dirty

