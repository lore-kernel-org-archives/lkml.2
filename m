Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1FZVFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:05:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59337 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab1FZVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EjtWS1fF8avypcK7gRxFUH3Hw0fhn9IbUTSvsA+/K21ft0ZgIjgFQXdpGEKETj1nQc
         x2h0CYCOl6ZmIEIrQqILyKbMWEOP4yBnlIKEi1UcRpEFW5Xg0oJmEdnfHSvY9xkm/OhI
         ONVvebcslmtopXtknmapkvvJHC2UriFaMNcJ8=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] finish modularization of ofpart parser
Date: Mon, 27 Jun 2011 01:02:58 +0400
Message-Id: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix building of kernel if MTD is selected as a module and OF_PARTS
is selected, finish modularization of ofpart MTD partition parser.

The following changes since commit 81e49819e7d6c11c91702d6b4d9fc71255614488:

  mtd: spelling, capitalization, uniformity (2011-06-24 22:58:01 +0300)

are available in the git repository at:
  git://git.infradead.org/users/dbaryshkov/mtd-cleanup.git mtd-big-cleanup

Dmitry Eremin-Solenikov (2):
      mtd: make ofpart buildable as a separate module
      mtd/ofpart: add ofoldpart alias

 drivers/mtd/Kconfig  |    3 ++-
 drivers/mtd/Makefile |    2 +-
 drivers/mtd/ofpart.c |    3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

