Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2GCLso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:48:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:38940 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2GCLsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:48:43 -0400
Date: Tue, 3 Jul 2012 21:48:40 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [GIT][v3.5] Security subsystem (updated)
In-Reply-To: <alpine.LRH.2.02.1207031244210.28166@tundra.namei.org>
Message-ID: <alpine.LRH.2.02.1207032147260.1293@tundra.namei.org>
References: <alpine.LRH.2.02.1207031244210.28166@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this instead.

The following changes since commit ca24a145573124732152daff105ba68cc9a2b545:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus2

Andy Lutomirski (1):
      security: document no_new_privs

Paul Mundt (1):
      security: Fix nommu build.

 Documentation/prctl/no_new_privs.txt |   50 ++++++++++++++++++++++++++++++++++
 security/security.c                  |    1 +
 2 files changed, 51 insertions(+)
 create mode 100644 Documentation/prctl/no_new_privs.txt
