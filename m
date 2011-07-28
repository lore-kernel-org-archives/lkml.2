Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1G1MqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:46:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39721 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1G1MqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:46:12 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/6] adjust array index
Date: Thu, 28 Jul 2011 14:46:00 +0200
Message-Id: <1311857165-14780-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where the upper bound of a loop is used as an array
indes, while it appears that the loop index should be used as the array
index.  I have only guessed that the code is incorrect, not actually tested
any of it.

