Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab2AITje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:39:34 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:42940 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab2AITjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:39:32 -0500
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] Updated TTY MAINTAINERS info
Date: Mon,  9 Jan 2012 17:39:24 -0200
Message-Id: <1326137964-10671-1-git-send-email-lucaskt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 12010919-9254-0000-0000-000007C54288
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman is the current TTY maintainer, however he wouldn't appear
listed as such upon running get_maintainers.pl for drivers under
drivers/tty/serial.

Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc6a466..6a856df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6641,7 +6641,7 @@ TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@suse.de>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
-F:	drivers/tty/*
+F:	drivers/tty/
 F:	drivers/tty/serial/serial_core.c
 F:	include/linux/serial_core.h
 F:	include/linux/serial.h
-- 
1.7.4.4

