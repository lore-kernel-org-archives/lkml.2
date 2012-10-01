Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2JAX53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:57:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55016 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JAX52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:28 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/12] ARM: soc: updates for 3.7, first batch
Date: Mon,  1 Oct 2012 16:56:55 -0700
Message-Id: <1349135827-24790-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the first batch of pull requests for arm-soc for this merge
window. Some of them are tiny, and we will probably start to combine
them into slightly larger misc branches in the future. I didn't do it
this time around since the dependencies between branches ended up quite
complex this time around.

We unfortunately have a somewhat conflict-heavy merge window in front
of us. The reason is a couple of substantial moves of header files and
Makefile contents on platforms. The shuffling is done to allow multiple
platforms to be built into the same kernel image, a goal that has
been worked towards for quite some time now and finally are bearing
fruit. We're starting out with just a few platforms but it's expected
that several more will be enabled for 3.8.

As usual I have described the conflicts in each pull request and how I
resolved them. I have also pushed up a temporary branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git merge-part1-resolved

that contains the merges as I have done them.

With that, here comes the first batch of updates. There will be a second
batch later on once these have been merged.


Thanks!

-Olof


