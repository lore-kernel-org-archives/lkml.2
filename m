Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2LNWn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:43:28 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48334 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2LNWnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:43:21 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Dec 2012 22:43:00 +0000
X-Google-Sender-Auth: 5ME1-X3Zy4qmSjxNUzKVIlz-s8c
Message-ID: <CACxGe6u56QU8RdJNvq=1qSESj9g=Hh_12zP_Astr1pcP1gs=LA@mail.gmail.com>
Subject: [GIT PULL] devicetree for v3.8 part 2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a couple more devicetree changes that I missed in the first
pull by putting the tag in the wrong place. Please pull.

g.

The following changes since commit 58fea354d887fddddd342a8d14b02069161ca904:

  arm64: Fix the dtbs target building (2012-12-10 20:24:57 -0600)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/devicetree-for-linus

for you to fetch changes up to 93c667ca2598bd84f1bd3f2fa176af69707699fe:

  of: *node argument to of_parse_phandle_with_args should be const
(2012-12-11 17:30:16 +0000)

----------------------------------------------------------------
Two minor devicetree fixups for v3.8. Addition of dummy inlines and
constification of node argument to of_parse_phandle_with_args().

----------------------------------------------------------------
Guennadi Liakhovetski (2):
      of/i2c: add dummy inline functions for when
CONFIG_OF_I2C(_MODULE) isn't defined
      of: *node argument to of_parse_phandle_with_args should be const

 drivers/of/base.c      |    2 +-
 include/linux/of.h     |    2 +-
 include/linux/of_i2c.h |   12 ++++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
