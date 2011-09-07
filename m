Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1IGQgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:36:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61919 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1IGQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:36:22 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 0/3] nbd: add support for DISCARD
Date: Wed,  7 Sep 2011 16:41:40 +0200
Message-Id: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for a DISCARD command in the nbd
protocol.  qemu-nbd will be the first user of the feature.

Please consider this for 3.2.

Thanks!

Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo Bonzini (3):
  nbd: remove unused flags fields
  nbd: add support for feature negotiation
  nbd: map DISCARD requests to a new nbd request type

 drivers/block/nbd.c |   28 ++++++++++++++++++++--------
 include/linux/nbd.h |   32 ++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 22 deletions(-)

-- 
1.7.6

