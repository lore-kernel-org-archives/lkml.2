Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab0JQSmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:42:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50826 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab0JQSmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:42:11 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/3] Use kasprintf
Date: Sun, 17 Oct 2010 20:48:28 +0200
Message-Id: <1287341311-11161-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches convert a sequence of kmalloc and memcpy to use kasprintf
instead.

