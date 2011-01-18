Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1AREPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:15:37 -0500
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:4928
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab1AREPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:15:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALOgNE18qSwg/2dsb2JhbACEDKBKc7MsjwyBJIM4dASEbYlv
X-IronPort-AV: E=Sophos;i="4.60,336,1291564800"; 
   d="scan'208";a="193590255"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 0/3] Fixes for vfs-scale and vfs-automount
To: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 18 Jan 2011 12:05:59 +0800
Message-ID: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed a couple of problems which needed to be fixed before I can
start testing.

Nick, David, can you check my changes please, particularly the cases
for the do_lookup() change.

---

Ian Kent (3):
      autofs4 - fix debug print in autofs4_lookup()
      vfs - fix dentry ref count in do_lookup()
      autofs4 - fix get_next_positive_dentry()


 fs/autofs4/expire.c |    4 ++--
 fs/autofs4/root.c   |    3 ++-
 fs/namei.c          |    5 ++++-
 3 files changed, 8 insertions(+), 4 deletions(-)

-- 
Ian
