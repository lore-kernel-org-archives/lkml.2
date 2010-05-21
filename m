Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab0EUWrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:47:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43909 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab0EUWrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:47:09 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 0/8] Suspend block api (version 8)
Date: Fri, 21 May 2010 15:46:47 -0700
Message-Id: <1274482015-30899-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a suspend-block api that provides the same
functionality as the android wakelock api. This version adds a
delay before suspending again if no suspend blockers were used
during the last suspend attempt.

--
Arve Hjønnevåg <arve@android.com>


