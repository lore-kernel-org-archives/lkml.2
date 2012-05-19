Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303Ab2ESAdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:33:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab2ESAdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:33:10 -0400
Date: Sat, 19 May 2012 01:33:03 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <thornber@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: [git pull] last-minute device-mapper fix for 3.4
Message-ID: <20120519003302.GB20415@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it's not too late, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.4-fixes-2

to get a last-minute fix for a problem discovered a couple of days ago.

Thanks,
Alasdair
 
----------------------------------------------------------------
A fix to the thin provisioning userspace interface.

----------------------------------------------------------------
Mike Snitzer (1):
      dm thin: fix table output when pool target disables discard passdown internally

 drivers/md/dm-thin.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)
