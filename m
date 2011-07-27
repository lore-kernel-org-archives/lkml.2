Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1G0Ozj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:55:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31066 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab1G0Ozf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:55:35 -0400
Message-ID: <4E3026DD.3030109@oracle.com>
Date: Wed, 27 Jul 2011 09:55:25 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] jfs update
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4E3026E4.00A8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_dmap.c   |    5 +----
 fs/jfs/jfs_txnmgr.c |    6 ++----
 fs/jfs/namei.c      |    3 +--
 3 files changed, 4 insertions(+), 10 deletions(-)

through this ChangeSet:

commit 7c6f49b9de29a8f60aa985a114cbd20687773247
Author: Dave Kleikamp <dave.kleikamp@oracle.com>
Date:   Mon Jun 20 13:00:27 2011 -0500

    jfs: clean up some compiler warnings
    
    jfs has a few variables being set but never used.
    
    Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
