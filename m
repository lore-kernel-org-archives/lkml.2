Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0H1PlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:41:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42042 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0H1PlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:41:18 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/7] Remove double test
Date: Sat, 28 Aug 2010 17:40:59 +0200
Message-Id: <1283010066-20935-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a case where the same expression is tested twice and the
answer is guaranteed to be the same in each case.

