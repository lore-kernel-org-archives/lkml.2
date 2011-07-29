Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab1G2Q3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:29:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39847 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1G2Q3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:29:21 -0400
Date: Fri, 29 Jul 2011 12:29:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] (xen) stable/bug.fixes for 3.1-rc0
Message-ID: <20110729162905.GA6606@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E32DFDC.00AB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes

which has patches since git commit 8ded371f81fba8b38a049f8c5f30ce6438fc7b75
Linus Torvalds (1):
    Merge branch 'for-3.1/drivers' of git://git.kernel.dk/linux-block

that are really small fixes - mostly compiler warnings and a compile failure
if the right set of CONFIGs is set.

Huang Weiyi (1):
      xen/pciback: remove duplicated #include

Konrad Rzeszutek Wilk (2):
      xen/grant: Fix compile warning.
      xen/balloon: Fix compile errors - missing header files.

 drivers/xen/grant-table.c        |    2 +-
 drivers/xen/xen-pciback/xenbus.c |    1 -
 drivers/xen/xen-selfballoon.c    |    4 ++--
 3 files changed, 3 insertions(+), 4 deletions(-)
