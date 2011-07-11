Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1GKS7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:59:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46940 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab1GKS7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:59:41 -0400
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 13:59:39 -0500
Message-ID: <CAH2r5muJCzah_VMaJz9J5gzfsZ8CcMK_-snyXeAbgz2o9Z4N7w@mail.gmail.com>
Subject: [GIT] CIFS Fixes
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit de3796e77a587b28f0c9d8e04c02894d3939dc4e:

  Merge branch 'v4l_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
(2011-07-06 12:16:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Jeff Layton (7):
      cifs: remove bogus call to cifs_cleanup_volume_info
      cifs: fix build_unc_path_to_root to account for a prefixpath
      cifs: have cifs_cleanup_volume_info not take a double pointer
      cifs: factor smb_vol allocation out of cifs_setup_volume_info
      cifs: move bdi_setup_and_register outside of CONFIG_CIFS_DFS_UPCALL
      cifs: fix expand_dfs_referral
      cifs: drop spinlock before calling cifs_put_tlink

 fs/cifs/cifsfs.c    |    8 ++--
 fs/cifs/cifsproto.h |    6 +-
 fs/cifs/connect.c   |  116 +++++++++++++++++++++++++++++----------------------
 3 files changed, 73 insertions(+), 57 deletions(-)


-- 
Thanks,

Steve
