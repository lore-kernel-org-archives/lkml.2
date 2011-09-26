Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1IZJlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:41:12 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:45250 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1IZJlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:41:11 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Sep 2011 05:41:11 EDT
From: Michael Cree <mcree@orcon.net.nz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 0/2] alpha: implement missing syscalls
Date: Mon, 26 Sep 2011 22:20:47 +1300
Message-Id: <1317028849-13198-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.4.3
X-DSPAM-Check: by mx4.orcon.net.nz on Mon, 26 Sep 2011 22:21:18 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Sep 26 22:21:18 2011
X-DSPAM-Confidence: 0.6190
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Patches to implement missing syscalls on Alpha follow.  I am sending to you
as the first one (the accept4 syscall) is really urgent and I am assuming
that Matt's alpha-next repository is out of action at the moment.  If
acceptable please forward to Linus.

I have tested the accept4 syscall with the test code in commit
de11defebf0000.

The accept4 patch should also be sent to the stable queue. It would be good
to get that into 3.0.x as that is the kernel currently in Debian Unstable
where the missing accept4 syscall is starting to cause havoc.

Cheers
Michael.

Michael Cree (2):
  alpha: Wire up accept4 syscall.
  alpha: Wire up sendmmsg syscall

 arch/alpha/include/asm/unistd.h |    4 +++-
 arch/alpha/kernel/systbls.S     |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

-- 
1.7.4.3

