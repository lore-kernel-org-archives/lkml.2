Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab2CZQIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:08:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49454 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab2CZQIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:08:24 -0400
MIME-Version: 1.0
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Mon, 26 Mar 2012 11:08:02 -0500
Message-ID: <CAFkjPTmxh7neMTNDTkus3NNLmjiUP2CiWAcDDWpdbom4D1A2ug@mail.gmail.com>
Subject: [GIT PULL] 9p changes for 3.4 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3c761ea05a8900a907f32b628611873f6bef24b2:

  Fix autofs compile without CONFIG_COMPAT (2012-02-26 09:44:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
for-linus-3.4-merge-window

Jim Garlick (3):
      net/9p: don't allow Tflush to be interrupted
      net/9p: handle flushed Tclunk/Tremove
      9p: statfs should not override server f_type

 fs/9p/vfs_super.c |    2 +-
 net/9p/client.c   |   26 +++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)
