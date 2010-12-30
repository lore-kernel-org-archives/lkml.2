Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0L3Bpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 20:45:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52062 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0L3Bpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 20:45:35 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Dec 2010 18:45:14 -0700
X-Google-Sender-Auth: SVfdhBRHjlQMgvGhkRJ5bB0IB58
Message-ID: <AANLkTimc2U==zvuRU67Bohsb5uCNjD8fX-6s7EefY6EQ@mail.gmail.com>
Subject: [git pull] one more spi bugfix for 2.6.37
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is one more spi bug fix for .37

The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:

  Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 merge-spi

Gregory CLEMENT (1):
      spi/omap2_mcspi.c: Force CS to be in inactive state after
off-mode transition

 drivers/spi/omap2_mcspi.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
