Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1D3LPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 07:15:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54000 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1D3LPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 07:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QEoXFQuqP8gq/NlZ5duy612M5QzXEwqZ2EZihEeoU5RYyvSNQaZFrXotsKh8YNXfsU
         uPQEYLFvSBExC3sZM/qVTdJX+9XvM1VE5hrsgoKyLNhOWaO1p5pXA8mmGvZ9CrDiEuJq
         lSav9gyi8LOX2RAOecOlpQ7SrdjZxHyhQn054=
Date: Sat, 30 Apr 2011 13:15:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thilo-Alexander Ginkel <thilo@ginkel.com>
Message-ID: <20110430111526.GA28147@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive fix for a deadlock
which can happen between rescuers and stop_machine() while bringing
down CPUs.  The problem could be half-reliably reproduced by
Thilo-Alexander while the system is entering suspend.  The branch also
contains another commit which documents workqueue debugging tricks.

The pull will cause conflict against 25985edced (Fix common
misspellings).  The fixed misspelling unfortunately was in the comment
which the fix replaces.  The conflict can be resolved by simply taking
the version from the fix commit.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git fixes-2.6.39

Thank you.

Florian Mickler (1):
      workqueue: Document debugging tricks

Tejun Heo (1):
      workqueue: fix deadlock in worker_maybe_bind_and_lock()

 Documentation/workqueue.txt |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c          |    8 +++++++-
 2 files changed, 47 insertions(+), 1 deletions(-)

-- 
tejun
