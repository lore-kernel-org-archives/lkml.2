Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967465Ab0GTAtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:49:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36136 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967428Ab0GTAtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:49:42 -0400
Date: Mon, 19 Jul 2010 20:48:06 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Btrfs update for 2.6.35-rc
Message-ID: <20100720004806.GE3133@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C44F28A.00DD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This batch has changes I've been testing in the master branch of the
btrfs-unstable repo

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

The first deals with the balancing bug that Edward Shishkin found.  The
others are bugs that have turned up during the rc.

Chris Mason (1) commits (+111/-18):
    Btrfs: fix split_leaf double split corner case

Dan Rosenberg (1) commits (+2/-2):
    Btrfs: fix checks in BTRFS_IOC_CLONE_RANGE

Sage Weil (1) commits (+13/-3):
    Btrfs: fix CLONE ioctl destination file size expansion to block boundary

Total: (3) commits (+126/-23)

 fs/btrfs/ctree.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c |   20 ++++++--
 2 files changed, 126 insertions(+), 23 deletions(-)
