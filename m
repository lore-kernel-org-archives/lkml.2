Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2JOKcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:32:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57364 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2JOKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:32:40 -0400
From: Chad Williamson <chad@dahc.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Cotey <puff65537@bansheeslibrary.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 0/5] staging: silicom: coding style fixes for bp_proc.c
Date: Mon, 15 Oct 2012 05:30:34 -0500
Message-Id: <1350297039-8166-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set corrects many of the coding style issues detected by
checkpatch.pl in bp_proc.c.

Chad Williamson (5):
  staging: silicom: fix whitespace in bp_proc.c
  staging: silicom: fix C99 comments in bp_proc.c
  staging: silicom: remove parentheses from return statements in bg_proc.c
  staging: silicom: remove unnecessary braces in bp_proc.c
  staging: silicom: fix explicit intialization of procfs_dir in bp_proc.c

 drivers/staging/silicom/bp_proc.c | 82 +++++++++++++++------------------------
 1 file changed, 31 insertions(+), 51 deletions(-)

-- 
1.7.12.2

