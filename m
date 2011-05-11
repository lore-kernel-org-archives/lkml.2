Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1EKTyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:54:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43465 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1EKTyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:54:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Hibernate fixes for 2.6.39
Date: Wed, 11 May 2011 21:54:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Alexandre Felipe Muller de Souza 
	<alexandrefm@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112154.42278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull three hibernate fixes for 2.6.39 and -stable from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

The first one fixes a recent regression, the other two fix problems
uncovered by the first one.  Since they all are -stable material and only
affect the "hybrid" suspend feature, I don't think there would be any advantage
from deferring them until the merge window opens.


 kernel/power/suspend.c |    4 ++--
 kernel/power/user.c    |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

---------------

Rafael J. Wysocki (3):
      PM: Fix warning in pm_restrict_gfp_mask() during SNAPSHOT_S2RAM ioctl
      PM / Hibernate: Make snapshot_release() restore GFP mask
      PM / Hibernate: Fix ioctl SNAPSHOT_S2RAM
