Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2LLQjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:39:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48302 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2LLQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:39:44 -0500
Date: Wed, 12 Dec 2012 08:39:42 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: [GIT PULL 0/5] ARM: arm-soc: First batch of updates for 3.8
Message-ID: <20121212163942.GA16036@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the first set of pull requests for arm-soc for this merge window.

Unfortunately we seem to have quite a few of little nagging merge conflicts for
this release. There's been some bugfixes upstream that conflicted with cleanups
and refactorings, and there's been a lot of header file moves that resulted in
include-section conflicts.

I've documented my proposed resolution in each pull request, and as usual
I have also pushed up my resulting merge as <branch>-resolved, in case you want
to diff.

There's only one gotcha that I am aware of, and that is for the 'cleanup'
branch, where a build break will be introduced if you don't fixup a
function name rename/conflict that isn't detected by git since the new
code was added with the old name in one of the branches. Not a big deal
if you miss it, we'll submit a patch to fix it up in that case.

I've got more to come, but wanted to break it up in a couple of batches. More
details in each pull request.


Thanks!


-Olof
