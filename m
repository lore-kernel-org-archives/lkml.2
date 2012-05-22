Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2EVFhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:37:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57599 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2EVFhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:34 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL 0/8] First batch of arm-soc branches for 3.5
Date: Mon, 21 May 2012 22:35:00 -0700
Message-Id: <1337664908-17478-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

These are the first 8 pull requests for arm-soc for the 3.5 merge window,
containing roughly half of our queued up changes.

Descriptions of each branch are in the corresponding request.

A few things to note:

* For reference I have pushed a merge-resolved branch against 47136855
  for every tag, to be found at resolved/<tagname>.

* There will be a conflict with the staging tree in two of the at91
  device tree files (at91sam9260.dtsi and at91sam9g20.dtsi). The
  version in arm-soc is the correct one (see
  http://marc.info/?l=linux-arm-kernel&m=133734654114734&w=2 for history).

* If you pull the staging tree before the 4th branch (device tree
  conversions), please also be aware of an automatic merge resolution error
  discovered in -next (see pull request for details, same thread as above).

* The 4th branch (device tree conversions) contains 4 patches that is
  also going through the embedded i2c tree. Wolfram agreed earlier that
  we could merge these through arm-soc so they are included here.


Thanks!

-Olof

