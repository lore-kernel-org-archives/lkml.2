Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1CBRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:25:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64419 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1CBRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=A1pPCkqaNgEw1wojseTu6JhoWpPHHP2oyy6AtutqyoExbHMwPh54PmFS8snz7IQLcn
         M2GNss6UEPJiFlr4cSYD3EN1g91+Juerjt/te8Ag477h5ElQ8U94wMP+hx5Dny3/h9i+
         b2uUxD5sDfjUKicQZ8o/0l/gs4PDORMbeR2xA=
Date: Wed, 2 Mar 2011 18:24:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL tip:x86/mm] fixes for memblock build warning and
 numa_distance handling
Message-ID: <20110302172446.GT3319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Ingo.

Please pull from the following git branch to receive two fix patches
for memblock build warning and numa_distance handling and a patch
adding comments to numa_distance code.  HEAD is eb8c1e2c83 (x86-64,
NUMA: Better explain numa_distance handling).

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

As usual, if HEAD doesn't appear, please pull from master.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

Thanks.

Tejun Heo (1):
      x86-64, NUMA: Better explain numa_distance handling

Yinghai Lu (2):
      mm: Move early_node_map[] reverse scan helpers under HAVE_MEMBLOCK
      x86-64, NUMA: Fix distance table handling

 arch/x86/mm/numa_64.c        |   19 ++++++++----
 arch/x86/mm/numa_emulation.c |   20 ++++++++----
 mm/page_alloc.c              |   64 +++++++++++++++++++++---------------------
 3 files changed, 58 insertions(+), 45 deletions(-)

-- 
tejun
