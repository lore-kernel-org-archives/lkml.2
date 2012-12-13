Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2LMGnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 01:43:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59115 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2LMGnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 01:43:12 -0500
Date: Wed, 12 Dec 2012 22:39:51 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>
Subject: [GIT PULL] linux-pstore.git
Message-ID: <20121213063950.GA11314@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here are just a few fixups for the pstore subsystem, nothing special this
time. Please pull.

Thank you!

The following changes since commit 70a6f46d7b0ec03653b9ab3f8063a9717a4a53ef:

  pstore: Fix NULL pointer dereference in console writes (2012-11-14 18:30:21 -0800)

are available in the git repository at:

  git://git.infradead.org/users/cbou/linux-pstore.git tags/for-v3.8

for you to fetch changes up to ebacfd1ece3bfa46296fc92c6f996cb5f7fc75e6:

  pstore/ftrace: Adjust for ftrace_ops->func prototype change (2012-12-12 19:50:04 -0800)

----------------------------------------------------------------
Anton Vorontsov (1):
      pstore/ftrace: Adjust for ftrace_ops->func prototype change

Arve Hjønnevåg (1):
      pstore/ram: Fix bounds checks for mem_size, record_size, console_size and ftrace_size

Hannes Reinecke (1):
      pstore/ram: Fixup section annotations

Maxime Bizon (1):
      pstore/ram: Fix undefined usage of rounddown_pow_of_two(0)

 fs/pstore/ftrace.c |  4 +++-
 fs/pstore/ram.c    | 42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 34 insertions(+), 12 deletions(-)
