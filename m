Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0KNOzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 09:55:40 -0500
Received: from freeflow.nu ([178.79.134.28]:46669 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab0KNOzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 09:55:39 -0500
Date: Sun, 14 Nov 2010 16:55:36 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB fixes for 2.6.37-rc2
Message-ID: <alpine.DEB.2.00.1011141654110.4490@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a small SLUB locking bug fix from Pavel Emelyanov.

                         Pekka

The following changes since commit 151f52f09c5728ecfdd0c289da1a4b30bb416f2c:
   Linus Torvalds (1):
         ipw2x00: remove the right /proc/net entry

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Pavel Emelyanov (1):
       slub: Fix slub_lock down/up imbalance

  mm/slub.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)
