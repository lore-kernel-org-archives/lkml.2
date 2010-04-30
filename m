Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838Ab0D3WhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 18:37:11 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:43528 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab0D3WhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 18:37:09 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/8] Suspend block api (version 6)
Date: Fri, 30 Apr 2010 15:36:53 -0700
Message-Id: <1272667021-21312-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a suspend-block api that provides the same
functionality as the android wakelock api. This version fixes a race
in suspend blocking work, has some documentation changes and
opportunistic suspend now uses the same workqueue as runtime pm.

--
Arve Hjønnevåg <arve@android.com>

