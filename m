Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1GHS6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:58:19 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:41600 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1GHS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:58:15 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] btrfs fixes
Date: Fri, 08 Jul 2011 14:55:51 -0400
Message-Id: <1310151138-sup-6548@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4E1752C1.0014:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has three more fixes.  We're fixing oopsen during space balancing (btrfs
filesystem balance /mnt)) and during device removal.

Dave Sterba also sent in a patch to make /proc/mounts properly match a
few new mount options, which he (correctly I think) considers a
regression fix because it makes it hard for testers/users to verify the
options in a running config.

Josef Bacik (1) commits (+2/-1):
    Btrfs: don't panic if we get an error while balancing V2

David Sterba (1) commits (+11/-0):
    btrfs: add missing options displayed in mount output

Miao Xie (1) commits (+7/-5):
    btrfs: fix oops when doing space balance

Total: (3) commits (+20/-6)

 fs/btrfs/ctree.h   |    5 +++++
 fs/btrfs/inode.c   |   12 +++++++-----
 fs/btrfs/super.c   |    6 ++++++
 fs/btrfs/volumes.c |    3 ++-
 4 files changed, 20 insertions(+), 6 deletions(-)
