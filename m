Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1CLKre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 05:47:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61732 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1CLKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 05:47:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=s7uDzgyqYbEP34j+oqTu7rx/K5IMNgMA92acaBy459OZJmEkE8v3OfcIKBXvLxIUXf
         fULcd8a0uA1qhU8HgWHtlJ5KwEt9/fNm8GuBLiXybffr79b0XRnO19hMFahjvBsGp+Fs
         q1Yr6lZf6gur6Kh+eHpVJdFhk5NDbdA2Vs+ck=
Date: Sat, 12 Mar 2011 11:47:27 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: [GIT PULL tip:x86/mm] x86-64 NUMA emulation update
Message-ID: <20110312104727.GA2005@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Please pull from the following branch to receive a commit which avoids
unnecessary MAX_NUMNODES^2 looping.  HEAD is 56396e682.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

As usual, if HEAD doesn't appear, please pull from master.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

Thanks.

Tejun Heo (1):
      x86-64, NUMA: Don't call numa_set_distanc() for all possible node combinations during emulation

 arch/x86/mm/numa_emulation.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

-- 
tejun
