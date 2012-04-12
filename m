Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966238Ab2DLWcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:32:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40284 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966128Ab2DLWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:32:23 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 12 Apr 2012 16:32:02 -0600
X-Google-Sender-Auth: e0UZlpFYF_4FUeqfdFyS-OsQZOc
Message-ID: <CACxGe6sNzO30-bK-ZumdfmYkCMyvYdNgwhbp4mhMrBTNK2wC8w@mail.gmail.com>
Subject: [GIT PULL] Another irqdomain bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I flubbed one patch in the last pull request which broke a format
string on 64 bit platforms.  Here's the fix.  Please pull.

g.

The following changes since commit ecca5c3acc0d0933d89abc44e60afb0cc8170e35:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-04-12 14:15:21 -0700)

are available in the git repository at:


  git://git.secretlab.ca/git/linux-2.6 tags/irqdomain-for-linus

for you to fetch changes up to 5269a9ab7def9a3116663347d59c4d70afa2d180:

  irq_domain: fix type mismatch in debugfs output format (2012-04-12
16:25:48 -0600)

----------------------------------------------------------------
irqdomain bug fixes for v3.4-rc3

Format string bug fix for irqdomain debug output on 64 bit platforms

----------------------------------------------------------------
Grant Likely (1):
      irq_domain: fix type mismatch in debugfs output format

 kernel/irq/irqdomain.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
