Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0FHWSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:18:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab0FHWRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:17:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Chow Loong Jin" <hyperair@ubuntu.com>,
       "Yan Zheng" <zheng.yan@oracle.com>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
In-Reply-To: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <C9Q3XEnHPeG.A.tVG.X8rDMB@chimera>
Subject: [Bug #16131] kernel BUG at fs/btrfs/extent-tree.c:4363 (btrfs_free_tree_block)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Jun 2010 00:10:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16131
Subject		: kernel BUG at fs/btrfs/extent-tree.c:4363 (btrfs_free_tree_block)
Submitter	: Chow Loong Jin <hyperair@ubuntu.com>
Date		: 2010-06-05 18:53 (4 days old)
Handled-By	: Yan Zheng <zheng.yan@oracle.com>
Patch		: https://patchwork.kernel.org/patch/103235/


