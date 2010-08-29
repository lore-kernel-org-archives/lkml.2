Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0H2Jwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:52:55 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50973 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0H2Jww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:52:52 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/7] Add of_node_put to avoid memory leak
Date: Sun, 29 Aug 2010 11:52:39 +0200
Message-Id: <1283075566-27441-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce calls to of_node_put after various functions that
call of_node_get.

