Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422982Ab2CPPNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352Ab2CPPNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:13:11 -0400
Subject: [GIT PULL] C6X: remove dead code from entry.S
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dhowells <dhowells@redhat.com>,
        "JACQUIOT-XID, Aurelien" <a-jacquiot@ti.com>
Date: Fri, 16 Mar 2012 11:13:06 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331910787.12353.6.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:

  Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to 6e780cf5c07ab85b9b1825ddd586a53ead10b579:

  C6X: remove dead code from entry.S (2012-03-16 09:27:57 -0400)

----------------------------------------------------------------
Remove dead code from entry.S which causes a build failure when using
a newer assembler (v2.22 complains about it, v2.20 ignores it).

----------------------------------------------------------------
Mark Salter (1):
      C6X: remove dead code from entry.S

 arch/c6x/kernel/entry.S |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)


