Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab0LMOCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:02:53 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36535 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab0LMOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:02:51 -0500
To: torvalds@linux-foundation.org
CC: htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: [git pull] fuse/cuse: fix ioctl interface
Message-Id: <E1PS8zF-0002J8-O1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 13 Dec 2010 15:02:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

These patches fix the unrestricted ioctl implementation.  Unrestricted
ioctl's are only enabled for character devices (CUSE) not for fuse
filesystems.

Thanks,
Miklos


Miklos Szeredi (2):
      fuse: fix ioctl when server is 32bit
      fuse: verify ioctl retries

---
 fs/fuse/file.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 66 insertions(+), 6 deletions(-)
