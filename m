Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1JMTw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:52:26 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:47800 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1JMTwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:52:25 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 13 Oct 2011 13:52:04 -0600
X-Google-Sender-Auth: __qg9EOfITDnPY9FRYnA-jL7kdE
Message-ID: <CACxGe6un6zVKQ=xZYwTeYDeQxvWvqJ6gaPv=VFkfs-C5xJM+Pw@mail.gmail.com>
Subject: [GIT PULL] gpio bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Oops, missed another bug fix.  Here's an updated pull request with
another gpio commit.

g.

The following changes since commit 37cf95162af4036b4198756a590aab8126fa2ce4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
(2011-10-13 18:25:45 +1200)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio/merge

Hartmut Knaack (1):
      gpio-pca953x: fix gpio_base

Janusz Krzysztofik (1):
      gpio/omap: fix build error with certain OMAP1 configs

 drivers/gpio/gpio-omap.c    |    2 +-
 drivers/gpio/gpio-pca953x.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
