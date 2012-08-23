Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262Ab2HWSzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:55:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37344 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2HWSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:55:44 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Davidlohr Bueso <dave@gnu.org>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cheng Renquan <crquan@gmail.com>
Subject: [PATCH v2 0/6] menuconfig: jump to search results
Date: Thu, 23 Aug 2012 14:55:02 -0400
Message-Id: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds "jump to" keys (similar to the cscope interface) to the
search results of "make menuconfig" so that we can go directly to the menu
entry for a config option after searching for it.

Patches 1-4 implement the basic functionality.
Patches 5-6 are an optional improvement.

Changes v1-v2:
* add a short description to patches 2 & 3
* correct checkpatch style warnings on patch 6

It should be targeted for v3.7

Enjoy,
-Benjamin

