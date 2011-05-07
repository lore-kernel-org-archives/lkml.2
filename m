Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1EGOLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 10:11:48 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:56268 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1EGOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 10:11:44 -0400
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH 0/2] ppc/cleaup: Fix compiler warnings
Date: Sat,  7 May 2011 17:11:29 +0300
Message-Id: <1304777491-7947-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.5.rc3
GIT: Lines beginning in "GIT:" will be removed.
GIT: Consider including an overall diffstat or table of contents
GIT: for the patch you are writing.
GIT: Clear the body content if you don't wish to send a summary.
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Sat, 07 May 2011 17:11:34 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compiler warnings in ppc code, which can lead to build failure, if
CONFIG_PPC_WERROR is set (default).

 arch/powerpc/include/asm/pgtable-ppc64.h |   13 ++++++-------
 arch/powerpc/kernel/Makefile             |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)
