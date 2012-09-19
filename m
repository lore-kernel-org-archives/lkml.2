Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2ISPaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:30:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34360 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab2ISP37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:29:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: raven@themaw.net
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com, mszeredi@suse.cz
Subject: [PATCH 0/2] struct pid-ify autofs4
Date: Wed, 19 Sep 2012 17:29:34 +0200
Message-Id: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These two patches change autofs4 to store struct pid pointers instead of pid_t
values.

Fixed various issues with the previous post.  Not tested, handle with care!

Thanks,
Miklos
---


Serge Hallyn (1):
      autofs4: store struct pids in autofs_waitqs

Sukadev Bhattiprolu (1):
      Replace pid_t in autofs4 with struct pid reference.

---
 fs/autofs4/autofs_i.h  |    8 ++++----
 fs/autofs4/dev-ioctl.c |    3 ++-
 fs/autofs4/inode.c     |   22 +++++++++++++++-------
 fs/autofs4/waitq.c     |   19 +++++++++++++------
 4 files changed, 34 insertions(+), 18 deletions(-)


