Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1BQOPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:15:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53522 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1BQOPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:15:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=At+lCmmAiOYYrDlTewRw4z6Zadz/aNsICxf7wPD3VkBk8mO401hF6rocQIrz7C/dgW
         EC1hZiy2n7FAH3/ppRtAWn1DdhyfAqM+yK/qOa/AKYXtAJxPcG19N3NNYfPSo9RPYM5N
         shJMUA6J0IFxkiuc26mz2EdZcHqe1+k/9uClE=
Date: Thu, 17 Feb 2011 15:15:14 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL tip:x86/mm] x86-64, NUMA: fixes for recent NUMA
 unification changes
Message-ID: <20110217141514.GW19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-numa

to receive two fixes for NUMA unification changes from Yinghai.  The
first one should fix the boot failure you saw.

HEAD is 6d496f9f232790d44144f3784856290e0b27b8f3.  git.korg is slow to
sync, if you can't see it, please pull from master.korg.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-numa

Thanks.

Yinghai Lu (2):
      x86-64, NUMA: Don't call __pa() with invalid address in numa_reset_distance()
      x86-64, NUMA: Put dummy_numa_init() in the init section

 arch/x86/mm/numa_64.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

-- 
tejun
