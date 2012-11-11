Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab2KKUy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 15:54:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38442 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2KKUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 15:54:57 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/3] Use dput() after d_find_alias().
Date: Sun, 11 Nov 2012 21:49:28 +0100
Message-Id: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A call to d_find_alias() needs a corresponding call to dput() in order to avoid
resource leaks.

The first patch is a Coccinelle scripts that looks for missing calls to dput().
The other two patches add calls to dput() where needed.

WBR,
Cyril Roelandt.
