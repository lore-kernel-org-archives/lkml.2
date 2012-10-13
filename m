Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2JMKUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 06:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab2JMKUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 06:20:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for spi
Date: Sat, 13 Oct 2012 11:20:18 +0100
Message-ID: <10604.1350123618@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you merge my spi disintegration patch please?

This is to complete part of the Userspace API (UAPI) disintegration for which
the preparatory patches were pulled recently.  After these patches, userspace
headers will be segregated into:

	include/uapi/linux/.../foo.h

for the userspace interface stuff, and:

	include/linux/.../foo.h

for the strictly kernel internal stuff.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-spi-20121009

for you to fetch changes up to 7939d3c2a677b06cf111a1304710dd97892f3695:

  UAPI: (Scripted) Disintegrate include/linux/spi (2012-10-09 09:49:03 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/spi

 include/linux/spi/Kbuild              | 1 -
 include/uapi/linux/spi/Kbuild         | 1 +
 include/{ => uapi}/linux/spi/spidev.h | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename include/{ => uapi}/linux/spi/spidev.h (100%)
.
