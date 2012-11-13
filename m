Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2KMPwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:52:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55204 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2KMPwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:52:39 -0500
Date: Tue, 13 Nov 2012 16:52:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 00/31] Latest numa/core patches, v15
Message-ID: <20121113155232.GA28466@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: quilt/0.51-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the latest iteration of our numa/core patches, which 
implements adaptive NUMA affinity balancing.

Changes in this version:

    https://lkml.org/lkml/2012/11/12/315

Performance figures:

    https://lkml.org/lkml/2012/11/12/330

Any review feedback, comments and test results are welcome!

For testing purposes I'd suggest using the latest tip:master 
integration tree, which has the latest numa/core tree merged:

   git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master

(But you can also directly use the tip:numa/core tree as well.)

Thanks,

    Ingo
