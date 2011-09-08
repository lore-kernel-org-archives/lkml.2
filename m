Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1IHHpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:45:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65133 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1IHHpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:45:10 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Clements <Paul.Clements@steeleye.com>, <nbd-general@lists.sf.net>
Subject: [PATCH v2 0/2] nbd: add support for DISCARD
Date: Thu,  8 Sep 2011 09:44:56 +0200
Message-Id: <1315467898-23984-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for a DISCARD command in the nbd
protocol.  qemu-nbd will be the first user of the feature.

Thanks!

v1->v2:
        Change ioctl name to NBD_SET_FLAGS and allow passing all
        flags in the network protocol.

Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: <nbd-general@lists.sf.net>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo Bonzini (2):
  nbd: add support for feature negotiation
  nbd: map DISCARD requests to a new nbd request type

 drivers/block/nbd.c |   10 ++++++++++++++++++++++--
 include/linux/nbd.h |   28 +++++++++++++++++---------------
 2 files changed, 39 insertions(+), 17 deletions(-)

-- 
1.7.6

