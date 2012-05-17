Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab2EQPtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:49:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2EQPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:49:19 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 0/4] slub: refactoring some code in slub
Date: Fri, 18 May 2012 00:47:44 +0900
Message-Id: <1337269668-4619-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are for refactoring some code in slub.

Two patches were submitted 1 weeks ago, but doesn't receive ack or nack
from MAINTAINER for slub. So I re-send these.

https://lkml.org/lkml/2012/5/10/273
https://lkml.org/lkml/2012/5/10/275

Among others, one about page-flag is very simple change.
Last one is main target of this patch set.

It is dependent on 'slub: change cmpxchg_double_slab in 
unfreeze_partials to __cmpxchg_double_slab', so I send these at one time.

Joonsoo Kim (4):
  slub: change cmpxchg_double_slab in get_freelist() to
    __cmpxchg_double_slab
  slub: change cmpxchg_double_slab in unfreeze_partials to
    __cmpxchg_double_slab
  slub: use __SetPageSlab function to set PG_slab flag
  slub: refactoring unfreeze_partials()

 mm/slub.c |   54 +++++++++++++++++-------------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

-- 
1.7.9.5

