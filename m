Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1AOM0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 07:26:39 -0500
Received: from freeflow.nu ([178.79.134.28]:56738 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1AOM0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 07:26:38 -0500
Date: Sat, 15 Jan 2011 14:26:35 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: [GIT PULL] SLAB changes for v2.6.38-rc1
Message-ID: <alpine.DEB.2.00.1101151426140.4320@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a fix for potential deadlock while accessing SLUB sysfs files
reported by Bart van Assche. The fix includes an out-of-topic change
to memory hotplug locking from Kamezawa-san.

There's also a minor SLAB cleanup from H Hartley Sweeten included.

                         Pekka

The following changes since commit 38567333a6dabd0f2b4150e9fb6dd8e3ba2985e5:
   Linus Torvalds (1):
         Merge git://git.kernel.org/.../jejb/scsi-post-merge-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab/urgent

Christoph Lameter (1):
       slub: Avoid use of slub_lock in show_slab_objects()

H Hartley Sweeten (1):
       mm/slab.c: make local symbols static

KAMEZAWA Hiroyuki (1):
       memory hotplug: one more lock on memory hotplug

Pekka Enberg (2):
       Merge branch 'slub/hotplug' into slab/urgent
       Update Pekka's email address in MAINTAINERS

  MAINTAINERS                    |    4 ++--
  include/linux/memory_hotplug.h |    6 ++++++
  mm/memory_hotplug.c            |    4 ++++
  mm/slab.c                      |    6 +++---
  mm/slub.c                      |    4 ++--
  5 files changed, 17 insertions(+), 7 deletions(-)
