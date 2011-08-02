Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1HBKf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:35:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59063 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab1HBKfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:11 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/11] trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:53 +0200
Message-Id: <1312281304-11847-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches convert conditionals containing only a call to BUG() to a
call to BUG_ON in some trivial cases.

