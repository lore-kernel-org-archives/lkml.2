Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1AUFmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 00:42:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51933 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1AUFmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 00:42:18 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Jan 2011 22:41:58 -0700
X-Google-Sender-Auth: Pqm6_HoxBcs7cuDs49qusKtRYpU
Message-ID: <AANLkTinuAQb_OyfoA-8ivgC7MnQYfiMai2wQKjtOj_-K@mail.gmail.com>
Subject: [git pull] devicetree build failure fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a fix for a stupid bug I introduced.

g.

The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:

  Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Grant Likely (1):
      powerpc/83xx: fix build failures on dt compatible list.

 arch/powerpc/platforms/83xx/mpc830x_rdb.c |    4 ++--
 arch/powerpc/platforms/83xx/mpc831x_rdb.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
