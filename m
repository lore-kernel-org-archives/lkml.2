Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1GVN4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:56:19 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:40845 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1GVN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:56:18 -0400
Date: Fri, 22 Jul 2011 15:56:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu changes for v3.1
Message-ID: <20110722135613.GN2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive percpu changes for
v3.1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.1

Another very boring pull request.  Some of __this_cpu_xchg* operations
were missing causing build failure on code which isn't upstream yet.
Christoph's patch fixes the problem.

Christoph Lameter (1):
      percpu: Fixup __this_cpu_xchg* operations

 arch/x86/include/asm/percpu.h |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

Thank you.

--
tejun
