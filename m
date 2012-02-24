Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2BXBjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:39:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63832 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2BXBjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.77.85 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: 
Date: Thu, 23 Feb 2012 20:38:47 -0500
Message-Id: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a number of cleanups in mei driver, mostly interrupt.c, to make
the code a bit more idiomatic and kernel-like.  The only patch which should
change the operation of the code is PATCH 4/9, where an obviously wrong "return
~Exxx" was fixed.

Broken apart by type of cleanup.  For reducing indentation, separated by how
complex the job was, from easiest to hardest.

 drivers/staging/mei/init.c        |    2 +-
 drivers/staging/mei/interrupt.c   |  799 +++++++++++++++++--------------------
 drivers/staging/mei/mei_dev.h     |    3 +-
 drivers/staging/mei/mei_version.h |    6 +-
 drivers/staging/mei/wd.c          |   23 +-
 5 files changed, 387 insertions(+), 446 deletions(-)

