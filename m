Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0DLUCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:02:54 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:16898 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0DLUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:02:53 -0400
Date: Mon, 12 Apr 2010 16:00:54 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20100412200054.GS13327@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BC37C46.0145:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

The last pull was missing two fixes, which you can find in the
master branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Josef's commit helps close another enospc problem, and the other one
fixes an oops where we try to allocate a zero sized extent off the
drive.

Chris Mason (1) commits (+6/-0):
    Btrfs: make sure the chunk allocator doesn't create zero length chunks

Josef Bacik (1) commits (+15/-5):
    Btrfs: fix data enospc check overflow

Total: (2) commits

 fs/btrfs/extent-tree.c |   20 +++++++++++++++-----
 fs/btrfs/volumes.c     |    6 ++++++
 2 files changed, 21 insertions(+), 5 deletions(-)
