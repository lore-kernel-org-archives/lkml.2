Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2LMBzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:55:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61257 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2LMBzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:55:45 -0500
Date: Wed, 12 Dec 2012 17:55:43 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: [GIT PULL 0/5] ARM: arm-soc: Second batch of pull requests
Message-ID: <20121213015543.GA18953@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the second batch of arm-soc changes for this merge window.

The first two branches have a handful of conflicts:
- The DT branch is mostly due to add/add changes but also due to some
  include changes/cleanup.
- The multiplatform branch contains some dependent pinctrl patches that
  seem to have been rebased either on the branch we received, or at the
  pinctrl side. Unfortunately we didn't catch it when it happened. It
  doesn't cause a whole lot of problems this time, luckily. We'll be
  more diligent on this in the future.

As before, conflict resolution documented in each pull request, and
-resolved branches pushed up for reference.

After this, we have about another 4 branches queued up, and possibly a
few more straggling patches on top of those.


Thanks!

-Olof
