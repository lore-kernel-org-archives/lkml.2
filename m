Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1JCSZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:25:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43392 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1JCSZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:25:24 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Btrfs" <linux-btrfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fix
Date: Mon, 03 Oct 2011 14:25:12 -0400
Message-Id: <1317666169-sup-1696@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E89FE12.0070,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Josef found a btrfs bug that can lead us to loop trying to fault in
pages during btrfs_file_write.  I've pushed the fix out to the btrfs git
tree.  Linus, please pull from the btrfs-3.0 branch:

git://github.com/chrismason/linux.git btrfs-3.0


Josef Bacik (1) commits (+16/-8):
    Btrfs: force a page fault if we have a shorty copy on a page boundary

Total: (1) commits (+16/-8)

 fs/btrfs/file.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)
