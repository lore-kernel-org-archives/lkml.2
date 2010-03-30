Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0C3HWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:22:47 -0400
Received: from lazybastard.de ([212.112.238.170]:57643 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0C3HWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:22:46 -0400
Date: Tue, 30 Mar 2010 09:22:36 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Please pull logfs tree for fixes
Message-ID: <20100330072236.GB11385@logfs.org>
References: <20100306210459.GA21570@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100306210459.GA21570@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning Linus!

I have a dozen fixes for you.  Some solve error path bugs, some are
necessary for the SSD that I never wanted to buy but finally did anyway
and the rest solve rather nasty bugs.

Al still has one error path problem I haven't dealt with yet.

 dev_bdev.c  |    9 +++++++--
 dir.c       |    4 ++--
 journal.c   |    7 +++++++
 logfs.h     |    1 +
 readwrite.c |   13 ++++++++++++-
 segment.c   |   54 +++++++++++++++++++++++++++++++-----------------------
 super.c     |   15 +++++++--------
 7 files changed, 67 insertions(+), 36 deletions(-)

git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git

Jörn

-- 
Joern's library part 11:
http://www.unicom.com/pw/reply-to-harmful.html
