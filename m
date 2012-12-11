Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2LKRmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:42:20 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50542 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2LKRmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:42:19 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6sL6p2_9n3yPip=h_ZHK3g7CjjnMpwGdQ6wiE7HrdRnTQ@mail.gmail.com>
References: <CACxGe6sL6p2_9n3yPip=h_ZHK3g7CjjnMpwGdQ6wiE7HrdRnTQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 11 Dec 2012 17:41:57 +0000
X-Google-Sender-Auth: fhboeKxMNb5nOYQ2vS4qqDeq-ho
Message-ID: <CACxGe6smjuSa-WYcEiy5DOqH_5wHz0X0d1hGJS82fdEF5fqSTg@mail.gmail.com>
Subject: Fwd: [GIT PULL] irqdomain changes for v3.8
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps when I CC the mailing list.  :-/

---------- Forwarded message ----------
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, Dec 11, 2012 at 5:34 PM
Subject: [GIT PULL] irqdomain changes for v3.8
To: Linus Torvalds <torvalds@linux-foundation.org>

Hi Linus.

This is all the irqdomain changes I have for v3.8. Please pull.

g.

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/irqdomain-for-linus

for you to fetch changes up to 023bba36387de704b3ea2a69bf9f9ed2301cfbcc:

  irqdomain: update documentation (2012-12-05 23:52:10 +0000)

----------------------------------------------------------------
irqdomain changes for Linux v3.8

Trivial changes to irqdomain. An update to the documentation and make
one of the error paths not quite so obnoxious.

----------------------------------------------------------------
Linus Walleij (2):
      irqdomain: stop screaming about preallocated irqdescs
      irqdomain: update documentation

 Documentation/IRQ-domain.txt |   34 +++++++++++++++++++++++++++++++++-
 kernel/irq/irqdomain.c       |    4 ++--
 2 files changed, 35 insertions(+), 3 deletions(-)


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
