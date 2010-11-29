Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab0K2Oq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:46:57 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47788 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0K2Oq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:46:56 -0500
Date: Mon, 29 Nov 2010 15:45:46 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Raoul Bhatia <r.bhatia@ipax.at>, Axel Lin <axel.lin@gmail.com>,
        Tracey Dent <tdent48227@gmail.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 37-rc4
Message-ID: <20101129144546.GA1170@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull three minor EDAC fixes from the branch below.

Thanks.

The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:

  Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Axel Lin (1):
      EDAC, MCE: Fix edac_init_mce_inject error handling

Raoul Bhatia (1):
      EDAC: Fix typos in Documentation/edac.txt

Tracey Dent (1):
      EDAC: Remove deprecated kbuild goal definitions

 Documentation/edac.txt     |    8 ++++----
 drivers/edac/Makefile      |    8 ++++----
 drivers/edac/mce_amd_inj.c |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
