Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3AHVhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:37:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:50527 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3AHVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:37:12 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: stefani@seibold.net
Subject: [PATCH 0/2] kfifo fixes
Date: Tue,  8 Jan 2013 22:36:19 +0100
Message-Id: <1357680984-23007-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0.2
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

As requested by Andrew Morton

- move the kfifo.c file from kernel/ to lib/ and
- fix the kfifo_alloc() and kfifo_init() to alloc at least the requested number of elements

Signed-off-by: Stefani Seibold <stefani@seibold.net>

