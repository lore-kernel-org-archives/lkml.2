Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0CVBFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:05:50 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59077 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0CVBFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:05:48 -0400
From: Christoffer Dall <christofferdall@christofferdall.dk>
To: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Christoffer Dall <christofferdall@christofferdall.dk>
Subject: [C/R ARM][PATCH 0/3] Linux Checkpoint-Restart - ARM port
Date: Sun, 21 Mar 2010 21:06:02 -0400
Message-Id: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following there will be two preparatory patches for an ARM port of the
checkpoint-restart code and finally a third patch implementing the
architecture-specific parts of c/r.

The preparatory patches consist of a systrace implementation for ARM
based on a previous patch from Roland McGrath and an eclone implementation
for ARM. The systrace implementation is partial and provides the needed
functionality for c/r.

There is a separate patch for the user space code, which supports
cross-compilation, extracting headers for ARM and an eclone implementation
for ARM.

The kernel patches presented here are based on the ckpt-v20 patch set.

Signed-off-by: Christoffer Dall <christofferdall@christofferdall.dk>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
