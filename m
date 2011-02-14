Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab1BNPTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:19:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51163 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab1BNPT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:19:27 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Feb 2011 08:19:06 -0700
X-Google-Sender-Auth: WwXxRYVrwK2mowomPPm2WRCezO4
Message-ID: <AANLkTi=dX4EjrF6qxw3oPOEJoV1PgrpiQimB=mSEzkBa@mail.gmail.com>
Subject: [git pull] Revert arm/dt documentation change that shouldn't have
 been merged yet
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I included a patch I shouldn't have in my last pull req.  This pull
req reverts it.  Thanks to Russell for pointing it out to me.

g.


The following changes since commit 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505:

  klist: Fix object alignment on 64-bit. (2011-02-13 16:54:24 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Grant Likely (1):
      Revert "dt: add documentation of ARM dt boot interface"

 Documentation/arm/Booting                       |   33 ++----------------
 Documentation/devicetree/booting-without-of.txt |   40 -----------------------
 2 files changed, 4 insertions(+), 69 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
