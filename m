Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0LDIAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 03:00:52 -0500
Received: from freeflow.nu ([178.79.134.28]:60305 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab0LDIAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 03:00:51 -0500
Date: Sat, 4 Dec 2010 10:00:38 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB fixes for 2.6.37-rc5
Message-ID: <alpine.DEB.2.00.1012040956400.6566@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's an urgent SLUB bug fix from Tero Roponen that fixes a 
root-triggerable oops.

                         Pekka

The following changes since commit 11e8896474495dec7ce19a542f67def847ec208f:
   Linus Torvalds (1):
         Merge branch '2.6.37-rc4-pvhvm-fixes' of git://xenbits.xen.org/people/sstabellini/linux-pvhvm

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab/urgent

Tero Roponen (1):
       slub: Fix a crash during slabinfo -v

  mm/slub.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)
