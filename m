Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab0FJLKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:10:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39146 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0FJLKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:41 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20100610110.764742110@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/23] Fix gcc 4.6 set but unused variable warnings
Date: Thu, 10 Jun 2010 13:10:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


gcc 4.6 -Wall gained a new set but unused variable warning.

First it was incredibly noisy, but when looking at it in detail it
actually found some bugs.

I haven't tried to fix all occurrences, but
at least the major ones for my configuration.

If someone is interested more work would be possible
on this.

There are still some warnings left, but no flood
and there's really usually some code improvement.

In a few cases I simply shut up the compiler, but
in many other cases dead code is gone or a real
problem has been fixed.

Some of the changes need more review (especially marked
and with suitable cc), but most are straight forward.

I did not fix all bugs -- those that were too hard
are just commented with the warning left in. 
I also marked areas that need more attention in
the individual patches.

Andrew, something for your tree?

-Andi
