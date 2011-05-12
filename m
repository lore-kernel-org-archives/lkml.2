Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab1ELPEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:04:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49862 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1ELPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:subject:cc:date:message-id:mime-version:content-type;
        b=i5dlbLaCKOYC9tuX93AQF61WL2Mffsc11UCpJFtLwBa3L0ZN0SfxOhCz7Xh9C/feRa
         bPbNHli/szQ05H0V5aUmLNcuJ3B6l0aPVQmk2rA3fJnSx8ZhGsJ066Oo461eyLSzgTiS
         Lj3B9Mqo9j6LhRG1IX19sBGKmJammlbHivrQ8=
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] fuse fix for 2.6.39
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Thu, 12 May 2011 17:04:48 +0200
Message-ID: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu>
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
----

Miklos Szeredi (1):
      fuse: fix oops in revalidate when called with NULL nameidata

---
 fs/fuse/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
