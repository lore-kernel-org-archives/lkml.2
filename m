Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004Ab2FAPyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:54:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35323 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964952Ab2FAPys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:54:48 -0400
Date: Fri, 1 Jun 2012 10:54:47 -0500
From: Robin Holt <holt@sgi.com>
To: WANG Cong <xiyou.wangcong@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Commit 722bc6b167 breaks booting on an 8TB system.
Message-ID: <20120601155447.GG3671@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried to boot an 8TB system.  It fails very early in boot with:

Kernel panic - not syncing: Cannot find space for the kernel page tables


A git bisect lead me to commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.

A git revert of that commit based on Linus' current as of a few hours ago
(commit fb21aff) does boot past that point on the 8TB configuration.

Thanks,
Robin
