Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0HVPSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 11:18:01 -0400
Received: from freeflow.nu ([178.79.134.28]:45755 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab0HVPSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 11:18:00 -0400
Date: Sun, 22 Aug 2010 18:17:58 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB fixes for 2.6.36-rc2
Message-ID: <alpine.DEB.2.00.1008221816590.3858@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's two minor bug fixes for SLAB and SLUB.

                         Pekka

The following changes since commit e36c886a0f9d624377977fa6cae309cfd7f362fa:
   Arjan van de Ven (1):
         workqueue: Add basic tracepoints to track workqueue execution

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Carsten Otte (1):
       slab: fix object alignment

Namhyung Kim (1):
       slub: add missing __percpu markup in mm/slub_def.h

  include/linux/slub_def.h |    2 +-
  mm/slab.c                |    4 ++--
  2 files changed, 3 insertions(+), 3 deletions(-)
