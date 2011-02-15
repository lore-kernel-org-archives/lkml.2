Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1BOJkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:40:32 -0500
Received: from tundra.namei.org ([65.99.196.166]:53599 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab1BOJka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:40:30 -0500
Date: Tue, 15 Feb 2011 20:39:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Wright <chrisw@sous-sol.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Airlie <airlied@gmail.com>, Dave Young <hidave.darkstar@gmail.com>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Alex Riesen <raa.lkml@gmail.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v3] pci: use security_capable() when checking capablities
 during config space read
In-Reply-To: <20110215012149.GM9869@sequoia.sous-sol.org>
Message-ID: <alpine.LRH.2.00.1102152038310.22204@tundra.namei.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi> <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com> <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com> <20110214003531.GH9869@sequoia.sous-sol.org> <alpine.LRH.2.00.1102141203430.12055@tundra.namei.org>
 <20110215012149.GM9869@sequoia.sous-sol.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also pullable from here:

The following changes since commit 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505:
  David Miller (1):
        klist: Fix object alignment on 64-bit.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Chris Wright (1):
      pci: use security_capable() when checking capablities during config space read

 drivers/pci/pci-sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
James Morris
<jmorris@namei.org>
