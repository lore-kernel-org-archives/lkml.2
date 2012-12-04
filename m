Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2LDKRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:17:14 -0500
Received: from ozlabs.org ([203.10.76.45]:58527 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab2LDKRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:17:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "James Hogan" <james.hogan@imgtec.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: [PULL] Module signing build fixes for blackfin and metag
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 04 Dec 2012 20:47:03 +1030
Message-ID: <87wqwygm00.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3c46f3d6406b1d0c53575774b2d1fd013cd7f76f:

  Merge branch 'for-3.7-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq (2012-12-01 17:55:13 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git fixes

for you to fetch changes up to 84ecfd15f5547c992c901df6ec14b4d507eb2c6e:

  modsign: add symbol prefix to certificate list (2012-12-03 13:06:25 +1030)

----------------------------------------------------------------
James Hogan (2):
      linux/kernel.h: define SYMBOL_PREFIX
      modsign: add symbol prefix to certificate list

 include/linux/kernel.h  |    7 +++++++
 kernel/modsign_pubkey.c |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)
