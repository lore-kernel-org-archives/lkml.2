Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2IKQ0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:26:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45421 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2IKQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:26:00 -0400
MIME-Version: 1.0
Date: Tue, 11 Sep 2012 19:25:59 +0300
X-Google-Sender-Auth: 55WKJov10lJVQbuEu89GkUPE7Wo
Message-ID: <CAOJsxLHaHhVXeh0bjvQT4_gYgGZAvasEUF_t_KBdAMPHBQuRQQ@mail.gmail.com>
Subject: [GIT PULL] SLAB fixes for v3.6-rc5
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

It has a PFMALLOC reserve page fixlet for slab from David Rientjes.

                        Pekka

------------------>
The following changes since commit 318e15101993c0fdc3f23f24ac61fc7769d27e68:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
(2012-08-29 11:36:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

David Rientjes (1):
      mm, slab: lock the correct nodelist after reenabling irqs

 mm/slab.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
