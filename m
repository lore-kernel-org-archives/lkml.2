Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1HOLvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:51:44 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28332 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1HOLvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:51:43 -0400
Message-ID: <4E490844.90206@oracle.com>
Date: Mon, 15 Aug 2011 06:51:32 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] jfs bug fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E49084D.000E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_umount.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

through these ChangeSets:

commit 1c8007b0769d37aa5fcb343b383b0af89ade2f71
Author: Dave Kleikamp <dave.kleikamp@oracle.com>
Date:   Mon Aug 1 12:41:00 2011 -0500

    jfs: flush journal completely before releasing metadata inodes
    
    This fixes a race during unmount. We need to not only make sure that
    the journal is completely written, but that the metadata changes make
    it to disk before releasing ipimap and ipbmap.
    
    Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
