Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1GNJtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:49:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55506 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1GNJte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:49:34 -0400
Date: Thu, 14 Jul 2011 11:49:29 +0200
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCHSET x86/mm] memblock, x86: Allow node info in memblock and
 remove x86 specific memblock code
Message-ID: <20110714094929.GI3455@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310462166-31469-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just posted one extra patch and several updated patches.  All the
updates were minor so I didn't want to resend the whole thing (yet).
It would probably be easiest to check the updated git branches.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-x86-mm-iter
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-x86-mm-memblock

git.korg is still synching.  The first one should be
8168136c0d47b53b7964385990710516c1199124 and the second
fb514c91dd44d9d88f29b20dddeeb8882bd89066.

Thank you.

-- 
tejun
