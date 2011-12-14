Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1LNO5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:57:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64932 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1LNO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:57:01 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [git pull] fuse fixes for 3.2
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 14 Dec 2011 15:56:08 +0100
Message-ID: <87borbcid3.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to receive the following fuse fixes.

Thanks,
Miklos
---

Miklos Szeredi (2):
      fuse: fix fuse_retrieve
      fuse: llseek fix race

Roel Kluin (1):
      fuse: fix llseek bug

---
 fs/fuse/dev.c  |    3 ++-
 fs/fuse/file.c |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)
