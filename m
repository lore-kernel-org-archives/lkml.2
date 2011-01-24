Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1AXEQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:16:44 -0500
Received: from ozlabs.org ([203.10.76.45]:46399 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1AXEQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:16:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] BUG_ON enhancements, remove MAYBE_BUILD_BUG_ON.
Date: Mon, 24 Jan 2011 14:46:41 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
        Hollis Blanchard <hollisb@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241446.41821.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   These have been sitting in linux-next for several releases; this makes
BUG_ON cover a wider range of cases, and removes MAYBE_BUILD_BUG_ON which
can fail entirely.  Also adds some docs for BUG_ON.

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git BUG_ON

Rusty Russell (2):
      BUILD_BUG_ON: make it handle more cases
      Remove MAYBE_BUILD_BUG_ON

 include/linux/gfp.h           |    2 +-
 include/linux/kernel.h        |   32 ++++++++++++++++++++++++++------
 include/linux/kmemcheck.h     |    2 +-
 include/linux/virtio_config.h |    5 ++++-
 4 files changed, 32 insertions(+), 9 deletions(-)
