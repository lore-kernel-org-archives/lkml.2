Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2B0AFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:05:31 -0500
Received: from ozlabs.org ([203.10.76.45]:52221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab2B0AFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:05:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Andreas =?utf-8?Q?Bie=C3=9Fmann?= <andreas@biessmann.de>
Subject: [PULL] modpost fix for cross-compiling
In-Reply-To: <4F4A5D6B.10102@bwalle.de>
References: <1329947735-4331-1-git-send-email-andreas@biessmann.de> <1330068233-12713-1-git-send-email-andreas@biessmann.de> <4F4A5D6B.10102@bwalle.de>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 27 Feb 2012 10:33:18 +1030
Message-ID: <87ipit2ldl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To git@github.com:rustyrussell/linux.git
   0d86f65..dd2a3ac  master -> master
 + e45f03a...65e65f9 for-linus -> for-linus (forced update)
The following changes since commit 203738e548cefc3fc3c2f73a9063176c9f3583d5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-02-26 12:47:17 -0800)

are available in the git repository at:

  git://github.com/rustyrussell/linux.git master

Andreas Bießmann (1):
      mod/file2alias: make modpost compile on darwin again

 scripts/mod/file2alias.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)
