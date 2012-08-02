Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2HBRos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:44:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58908 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2HBRor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:44:47 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
Date: Thu, 2 Aug 2012 10:44:46 -0700
Message-ID: <CAOesGMgJjJd=69AgNZFSOWvEqjRO3=SspY5rUQxwVnWr5fe2uQ@mail.gmail.com>
Subject: [GIT PULL 0/3] ARM: late-arrived arm-soc branches for 3.6
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following 3 pull requests (well, the latter two) are for branches
that showed up late for this merge window but we staged anwyay, on a
best-effort basis.

2/3 is for grouped cpuidle updates on OMAP which missed 3.5 due to the
infrastructure not going in. Since it's well-contained to their
platform, and they are eager to see it go in, I picked it up and let
it sit in -next for about a week and I think it's good to go by now.

3/3 is device-tree updates for Marvell Orion. The maintainers and
developers on these platforms are mostly hobbyists so we're trying to
help them get used to the workflow, etc, and in this case it meant
they needed a little while to get the branches sorted out. The code is
reasonably well-contained and again has sat in linux-next for almost a
week.


That being said, we are flexing the rules a bit here and if you're
less than excited to pick these up at this time, let us know and we
can hold them until the 3.7 window instead.

Please do merge the first branch of fixes though.


Thanks!

-Olof
