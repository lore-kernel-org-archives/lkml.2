Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1ISOuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:50:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38366 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1ISOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:50:13 -0400
Date: Mon, 19 Sep 2011 17:50:09 +0300 (EEST)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@localhost6.localdomain6
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLUB fix for v3.1-rc7
Message-ID: <alpine.DEB.2.00.1109191748030.7992@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a one-line SLUB hackbench performance regression fix from Shaohua 
Li. It's been sitting in linux-next for a while now and wasn't sent to you 
earlier due to git.kernel.org issues.

                         Pekka

The following changes since commit b0e7031ac08fa0aa242531c8d9a0cf9ae8ee276d:

   Merge git://github.com/davem330/net (2011-09-18 11:02:26 -0700)

are available in the git repository at:

   git@github.com:penberg/linux.git slab/urgent

Shaohua Li (1):
       slub: add slab with one free object to partial list tail

  mm/slub.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)
