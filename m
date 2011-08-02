Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1HBQCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:02:18 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:41999 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab1HBQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:02:10 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 2 Aug 2011 17:01:47 +0100
X-Google-Sender-Auth: -NjBUOVUFrkAxbT2dEnJ8AFgBpI
Message-ID: <CACxGe6scX-2jv9MuuNUMZZ1u_mOwe79FxFdm2BOt=V-GNhNs8w@mail.gmail.com>
Subject: [GIT PULL] an spi bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: spi-devel-general@lists.sourceforge.net,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5f66d2b58ca879e70740c82422354144845d6dd3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
(2011-08-01 06:14:25 -1000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/next

Linus Walleij (1):
      spi/pl022: remove function cannot exit

 drivers/spi/spi-pl022.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
