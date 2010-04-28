Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008Ab0D1EcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 00:32:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37211 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0D1EcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 00:32:12 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/9] Suspend block api (version 5)
Date: Tue, 27 Apr 2010 21:31:51 -0700
Message-Id: <1272429119-12103-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a suspend-block api that provides the same
functionality as the android wakelock api. The main change from
version 4 posted last week is that suspend blocking work has moved out
of the core workqueue code. The documentation has also been updated.

--
Arve Hjønnevåg <arve@android.com>

