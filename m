Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0JUFWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 01:22:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54425 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0JUFWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 01:22:02 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: greg@kroah.com, linux-bluetooth@vger.kernel.org
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] Bluetooth: fix crash in L2CAP
Date: Thu, 21 Oct 2010 03:19:52 -0200
Message-Id: <1287638393-8573-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The following patch is good for 2.6.36.1. It arrived too late in linux-bluetooth
and we didn't had time to put it into 2.6.36. It fixes a serious crash into
the L2CAP layer. The issue isn't in 2.6.35 and below.

Thanks.

Nathan Holstein (1):
  Bluetooth: fix oops in l2cap_connect_req

 net/bluetooth/l2cap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.3.1

