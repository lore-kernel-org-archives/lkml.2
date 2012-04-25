Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab2DYL2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:28:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:33051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab2DYL2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:28:45 -0400
Message-Id: <20120425111552.665217867@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 25 Apr 2012 13:15:52 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] math128 - v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take two of the math128 bits.. 

Changes since last time:
 - Added gcc __int128 versions for where it works
 - Added Andy's mul_u64_u32_shr() due to popular demand :-)
 - Added {shl,shr}_u128 as requested by hpa (although I suspect he'll
   use Andy's fancy function).
 - Added a U128_INIT() constant initializer.
 - Renamed mult_u128 to mul_u64_u64, hpa complaned the name was
   misleading
 - Fixed some of the code generation issues with add_u128 and
   mul_u64_64.

I've also assumed we're all actually ok with adding this functionality,
so unless someone hollers I'll push this for inclusion.

