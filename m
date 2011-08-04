Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1HDK3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:29:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59158 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab1HDK3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:29:40 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/4] delete useless initialization
Date: Thu,  4 Aug 2011 12:29:30 +0200
Message-Id: <1312453774-23333-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where a variable is initialized in some non-trivial
way, and the result is immediately overwritten with the result of some
allocation function.

