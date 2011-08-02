Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1HBPzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:55:05 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:39433 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1HBPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:55:03 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 2 Aug 2011 16:54:39 +0100
X-Google-Sender-Auth: 3j9o9Ko3ZU_-BrbMGkKpt1EH95U
Message-ID: <CACxGe6vFT6daeE+5EsbDtEeUV-sYZgcMQd_=GSR+kqre7Opkgw@mail.gmail.com>
Subject: [GIT PULL] device tree fixes for v3.1
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not much here to talk about here.  Pretty boring stuff.

g.

The following changes since commit 5f66d2b58ca879e70740c82422354144845d6dd3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
(2011-08-01 06:14:25 -1000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/next

Felipe Balbi (1):
      of: address: use resource_size helper

Jamie Iles (1):
      of: constify property name parameters for helper functions

Michal Simek (1):
      input: xilinx_ps2: Add missing of_address.h header

 drivers/input/serio/xilinx_ps2.c |    2 +-
 drivers/of/address.c             |    2 +-
 drivers/of/base.c                |    7 ++++---
 include/linux/of.h               |   15 +++++++++------
 4 files changed, 15 insertions(+), 11 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
