Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab2FGIUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:20:31 -0400
Received: from www84.your-server.de ([213.133.104.84]:39284 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2FGIU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:27 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] fix usb skeleton driver
Date: Thu,  7 Jun 2012 10:20:30 +0200
Message-Id: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This is a fix for the USB skeleton driver to bring it in shape.

- Code cleanup
- Eliminated dead code
- Handle a non blocking read without blocking
- Fix a small race condition
- Introduced fsync
- Single user mode

The patch is against linux 3.5.0 commit eea5b5510fc5545d15b69da8e485a7424ae388cf

Hope this helps

Signed-off-by: Stefani Seibold <stefani@seibold.net>
