Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1LWVCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:02:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab1LWVCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:02:46 -0500
Date: Fri, 23 Dec 2011 22:02:41 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pebolle@tiscali.nl, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig update-po-config fix
Message-ID: <20111223210241.GA23076@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a fix for 'make update-po-config', that broke after a UML
change. I personally don't consider transation of kconfig files extra
important and the project doing this seems dead, but it broke in 3.2, so
let's fix it in 3.2.

Thanks,
Michal

The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

Paul Bolle (1):
      kconfig: adapt update-po-config to new UML layout

 scripts/kconfig/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)
