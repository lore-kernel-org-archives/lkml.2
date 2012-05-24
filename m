Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966093Ab2EXT7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:59:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64883 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966012Ab2EXT7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:59:30 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 24 May 2012 13:59:09 -0600
X-Google-Sender-Auth: M4tQJka-hrbLcHE3nNP2RrqSjYg
Message-ID: <CACxGe6tV-3KkOBCgvmJBvc=Os4Dw32uHOdd_XPEw3RrZs-snog@mail.gmail.com>
Subject: [GIT PULL] irqdomain changes for v3.5 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Description below.  Please pull.

g.

The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/irqdomain-for-linus

for you to fetch changes up to a87487e687ceafdc696b8cb1fb27e37cc463586b:

  irqdomain: Document size parameter of irq_domain_add_linear()
(2012-05-19 13:07:51 -0600)

----------------------------------------------------------------
irqdomain changes for v3.5 merge window

Minor changes and fixups for irqdomain infrastructure.  Most
important change adds ability to remove registered irqdomain.

----------------------------------------------------------------
Mark Brown (1):
      irqdomain: Document size parameter of irq_domain_add_linear()

Paul Mundt (5):
      irqdomain: Support removal of IRQ domains.
      irqdomain: Export remaining public API symbols.
      irqdomain: Make irq_domain_simple_map() static.
      irqdomain: Kill off duplicate definitions.
      irqdomain: trivial pr_fmt conversion.

 include/linux/irqdomain.h |    3 +-
 kernel/irq/irqdomain.c    |  106 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 89 insertions(+), 20 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
