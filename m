Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2ECJhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:37:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54260 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab2ECJhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:37:51 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 0/2] ideapad: some minor fix
Date: Thu,  3 May 2012 17:37:45 +0800
Message-Id: <1336037865-9918-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are also available in the git repository at:
  git://kernel.ubuntu.com/ikepanhc/public.git ideapad-next

Ike Panhc (2):
  ideapad: remove unused define and fix a typo
  ideapad: generate valid key event only

 drivers/platform/x86/ideapad-laptop.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
1.7.9.5

