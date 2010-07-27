Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0G0T5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:57:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33661 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0G0T5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:57:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tTHcOj8UOziSmPKpXLXyvwewGDF1GdBFJZCRehtwhC5p09y+AkXfVdDkrBFEi2Ey9t
         GidTwq+NVoqqHa65m5ejRyCArWrUSrD/HWKoHce/6sm0567IWlYXK8tr34p6SOkuFTim
         I7lz4ngvNOieQj118kVI9gQFL53FSdrQkaML0=
MIME-Version: 1.0
Date: Tue, 27 Jul 2010 14:57:21 -0500
Message-ID: <AANLkTikhMAgf0aqGGWMj-h=K1n4gcTu8KQ0=9+nHe5-h@mail.gmail.com>
Subject: [GIT PULL] 9p file system bug fix for rc6
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know you are trying to finalize things, but this small fix seems
like its worth fixing before release.  I'm holding back everything
else until the merge window.
Thanks,

     -eric


The following changes since commit d15aa2cc641bd193596382357de917b32f1b40cb:
  Linus Torvalds (1):
        Merge branch 'urgent' of git://git.kernel.org/.../paulus/perf

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Latchesar Ionkov (1):
      9p: Pass the correct end of buffer to p9stat_read

 fs/9p/vfs_dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
