Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1HINou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:44:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56887 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1HINot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:44:49 -0400
Date: Tue, 9 Aug 2011 16:44:40 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLUB fixes for v3.1-rc1
Message-ID: <alpine.DEB.2.00.1108091644170.2453@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's two SLUB debugging fixes. The most important one is the full list
corruption issue reported by multiple people when SLUB debugging is enabled.
The other one is from Akinobu Mita that fixes up debugging byte pattern
checking.

                         Pekka

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:
   Linus Torvalds (1):
         Linux 3.1-rc1

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab/urgent

Akinobu Mita (1):
       slub: fix check_bytes() for slub debugging

Christoph Lameter (1):
       slub: Fix full list corruption if debugging is on

  mm/slub.c |    8 +++++---
  1 files changed, 5 insertions(+), 3 deletions(-)
