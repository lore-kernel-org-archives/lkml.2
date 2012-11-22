Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2KVTq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:46:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59763 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab2KVTqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:46:51 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, alan@lxorguk.ukuu.org.uk, wfp5p@virginia.edu,
        geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 0/2] staging/dgrp/dgrp_tty.c: audit function return values
Date: Fri, 23 Nov 2012 01:16:33 +0530
Message-Id: <1353613595-8505-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes two issues in dgrp driver:
i) Removes the TIOCSSOFTCAR ioctl handler from dgrp driver so as to allow the
core tty layer to take care of this ioctl instead.

ii) Audits the return value of get_user() and put_user() and return -EFAULT in
case of error.

-- 
1.7.9.5

