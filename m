Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0DWBJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:09:38 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:50164 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab0DWBJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:09:37 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Suspend block api (version 4)
Date: Thu, 22 Apr 2010 18:08:49 -0700
Message-Id: <1271984938-13920-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a suspend-block api that provides the same
functionality as the android wakelock api. The code is mostly the
same as version 3 posted last year, but the main entry point has
changed back to /sys/power/state with a new /sys/power/policy to
alter its behavior. Timeout support is not included in this initial
patchset.

--
Arve Hjønnevåg <arve@android.com>


