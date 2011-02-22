Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1BVLUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:20:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40852 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab1BVLUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:20:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Hjd+SWcnXbq181bnU00uwdyFKyCbZ4kjqD0goxMuXeUnxow3N+211EKpTFxLuiVJ+3
         awzdI8t3ZkJEQZJzRqY1/nR1ygNMAQzGOGIPUPwVydkp/+fu+LM0gZHbUpwIeMXg1lrM
         S/7VIGgS7U2UnIvZzSOEWP+IgvD5P7ib2li80=
Date: Tue, 22 Feb 2011 12:20:27 +0100
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, yinghai@kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL tip:x86/mm] x86-64, NUMA: NUMA related misc changes
Message-ID: <20110222112027.GA31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from the following git branch to receive five
commits updating x86-64 NUMA code.  These five patches shouldn't cause
any visible behavior change.  The HEAD is 2bf50555b0 (x86-64, NUMA:
Seperate out numa_alloc_distance() from numa_set_distance()).

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-numa

git.korg still seems a bit slow to sync, so if you can't see the HEAD
there please pull from master.korg.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-numa

Thanks.

Tejun Heo (3):
      x86-64, NUMA: Prepare numa_emulation() for moving NUMA emulation into a separate file
      x86-64, NUMA: Move NUMA emulation into numa_emulation.c
      x86-64, NUMA: Add proper function comments to global functions

Yinghai Lu (2):
      x86-64, NUMA: Do not scan two times for setup_node_bootmem()
      x86-64, NUMA: Seperate out numa_alloc_distance() from numa_set_distance()

 arch/x86/mm/Makefile         |    1 +
 arch/x86/mm/numa_64.c        |  629 +++++++-----------------------------------
 arch/x86/mm/numa_emulation.c |  475 +++++++++++++++++++++++++++++++
 arch/x86/mm/numa_internal.h  |   31 ++
 4 files changed, 607 insertions(+), 529 deletions(-)
 create mode 100644 arch/x86/mm/numa_emulation.c
 create mode 100644 arch/x86/mm/numa_internal.h


-- 
tejun
