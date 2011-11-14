Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1KNPUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:20:45 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42723 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1KNPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:20:44 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Nov 2011 10:20:44 EST
Date: Mon, 14 Nov 2011 16:13:00 +0100
From: Adrian Reber <adrian@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Oren Laadan <orenl@cs.columbia.edu>, matt.helsley@gmail.com,
        Peter =?iso-8859-1?Q?V=E4terlein?= 
	<Peter.Vaeterlein@hs-esslingen.de>
Subject: linux-cr ported to 3.2-rc1
Message-ID: <20111114151300.GT16442@lisas.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: <http://lisas.de/~adrian/>
X-Operating-System: Linux (2.6.35.13-92.fc14.x86_64)
X-Load-Average: 4.09 3.70 3.51
X-Unexpected: The Spanish Inquisition
X-GnuPG-Key: gpg --recv-keys 3ED6F034
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have ported the linux-cr patches from www.linux-cr.org/pub/git/linux-cr.git
to the latest kernel (3.2-rc1). The tests (on x86_64) I have done so far
were successful. My repository with the C/R patches on top of 3.2-rc1 is
currently at:

http://lisas.de/~adrian/linux-cr.git


The development on the linux-cr tree hast stopped sometime around 2.6.37
and although those patches have gone through many revisions I am not sure
about the latest state of those patches concerning inclusion. At what
point has the discussion stopped and why?

I have seen patches from Pavel about another approach for 
checkpointing/restarting but I haven't heard anything about
that during the last months.

What are the chances to get one of the checkpointing/restarting
implementations included. What is still missing from the one I used?
What is the latest state of Pavel's patches?

		Adrian
