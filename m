Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab2E1NBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:01:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab2E1NBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:01:42 -0400
Date: Mon, 28 May 2012 15:01:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: [GIT] doc
Message-ID: <alpine.LNX.2.00.1205281451411.15057@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git doc

to receive documentation updates. I am currently relaying documentation 
patches through 'doc' branch of trivial tree, until Rob, the new 
documentation maintainer, has established a proper tree.

Thanks.

Marcos Paulo de Souza (1):
      Documentation/initrd.txt: Change the location of util-linux

Michel Machado (1):
      Documentation/SubmittingPatches: suggested the use of scripts/get_maintainer.pl

Sebastian Andrzej Siewior (1):
      Documentation/kernel-parameters: remove autotest and mcatest

Stefan Hajnoczi (1):
      doc: ext3: update documentation with barrier=1 default

 Documentation/SubmittingPatches     |    3 ++-
 Documentation/filesystems/ext3.txt  |    6 +++---
 Documentation/initrd.txt            |    4 ++--
 Documentation/kernel-parameters.txt |    4 ----
 4 files changed, 7 insertions(+), 10 deletions(-)

-- 
Jiri Kosina
SUSE Labs
