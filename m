Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1EWMT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1EWMT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:19:56 -0400
Date: Mon, 23 May 2011 14:18:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] unify compat/native exec for v2.6.40
Message-ID: <20110523121806.GA6784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git exec_rm_compat

Unifies compat/native do_execve() code. Based on discussion with you
and Kosaki.

Oleg Nesterov (4):
      exec: introduce get_user_arg_ptr() helper
      exec: introduce struct user_arg_ptr
      exec: unify do_execve/compat_do_execve code
      exec: document acct_arg_size()

 fs/compat.c             |  235 -----------------------------------------------
 fs/exec.c               |  125 ++++++++++++++++++++-----
 include/linux/binfmts.h |    4 -
 3 files changed, 100 insertions(+), 264 deletions(-)

