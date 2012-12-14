Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2LNWEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:04:46 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46826 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab2LNWEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:04:43 -0500
Date: Fri, 14 Dec 2012 14:04:41 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/3] ARM: arm-soc: Third and final batch foe 3.8
Message-ID: <20121214220441.GA11363@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the last batch of branches for 3.8. It's wrapping up merges for
SPEAr and socfpga, some additional contents for Exynos and shmobile and
a large update for mvebu/kirkwood.

For kirkwood, we're working on figuring out the workflow better with the
submaintainers, they have a rapid pace of development and end up with a
lot of interdependent topic branches. So we grouped them in a topic on
their own this merge window; something we're trying to avoid overall.

Same procedure as last time, merge conflicts documented in each request
and *-resolved branches pushed for reference.

And thanks for your tolerance of merge conflicts in this merge window,
it's been a relatively bad one and we'll work to avoid more of the silly
ones for 3.9.

>From here on out it'll mostly be fixes, and possibly a few straggling
patches.


Thanks,

-Olof
