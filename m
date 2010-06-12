Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab0FLSHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 14:07:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:38673 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0FLSHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 14:07:37 -0400
Date: Sat, 12 Jun 2010 20:07:35 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: khc@pm.waw.pl, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild modpost fix
Message-ID: <20100612180735.GA31404@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull another kbuild fix. This time it's a pointer arithmetics
overflow in modpost that started to show up with newer gcc.

Thanks,
Michal

The following changes since commit 607b30fcf20c6e5339591692db6ffa0b15e041a0:

  kbuild: Create output directory in Makefile.modbuiltin (2010-06-10 12:23:08 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Krzysztof Halasa (1):
      kbuild: Fix modpost segfault

 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
