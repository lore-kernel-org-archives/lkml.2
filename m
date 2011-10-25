Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1JYIwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:52:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1JYIwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:52:42 -0400
From: hamo.by@gmail.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        gregkh@suse.de, davem@davemloft.net
Cc: grant.likely@secretlab.ca, Yang Bai <hamo.by@gmail.com>
Subject: [PATCH] MAINTAINERS: update gpio subsystem file list
Date: Tue, 25 Oct 2011 16:52:27 +0800
Message-Id: <1319532747-3223-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Bai <hamo.by@gmail.com>

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51a8160..c1029e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2851,6 +2851,7 @@ T:	git git://git.secretlab.ca/git/linux-2.6.git
 F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
+F:	include/asm-generic/gpio.h
 
 GRE DEMULTIPLEXER DRIVER
 M:	Dmitry Kozlov <xeb@mail.ru>
-- 
1.7.7

