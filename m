Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1ILHa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:30:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35613 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1ILHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:30:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] fuse fixes for 3.1
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Sep 2011 09:30:50 +0200
Message-ID: <877h5ez07p.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please apply the following two fuse patches.

Thanks,
Miklos
----


Miklos Szeredi (2):
      fuse: fix memory leak
      fuse: fix flock breakage

---
 fs/fuse/dev.c   |   12 ++++++++----
 fs/fuse/inode.c |    3 +++
 2 files changed, 11 insertions(+), 4 deletions(-)
