Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2LAAAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:00:07 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44870 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2LAAAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:00:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvKUAWkTCwdrcYZ+MnsgC7JLyouteiG=ER1_nzbFdX40A@mail.gmail.com>
References: <CAH2r5mvKUAWkTCwdrcYZ+MnsgC7JLyouteiG=ER1_nzbFdX40A@mail.gmail.com>
Date: Fri, 30 Nov 2012 18:00:05 -0600
Message-ID: <CAH2r5mtv5Q0kkotOCNmi92cthWkxMhmaagJQqJZqoXgYDOS+GQ@mail.gmail.com>
Subject: Fwd: [GIT] 2 CIFS Fixes for Regressions
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Steve French <smfrench@gmail.com>
Date: Fri, Nov 30, 2012 at 5:59 PM
Subject: [GIT] 2 CIFS Fixes for Regressions
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org


Resending the merge request from earlier in the week.  These are two
low risk, small fixes, that fix cifs regressions introduced in 3.7.

The following changes since commit 5e351cdc998db82935d1248a053a1be37d1160fd:

  Merge tag 'devicetree-for-linus' of
git://git.secretlab.ca/git/linux-2.6 (2012-11-23 12:36:06 -1000)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-linus

Jeff Layton (1):
      cifs: fix writeback race with file that is growing

Pavel Shilovsky (1):
      CIFS: Fix wrong buffer pointer usage in smb_set_file_info

 fs/cifs/file.c    |    6 +++---
 fs/cifs/smb1ops.c |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

--
Thanks,

Steve


-- 
Thanks,

Steve
