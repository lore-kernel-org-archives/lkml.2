Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2AXJIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:08:53 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:65030 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab2AXJIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:08:50 -0500
Date: Tue, 24 Jan 2012 10:08:45 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        netdev@vger.kernel.org
Cc: giancarlo.asnaghi@st.com
Subject: [PATCH 0/3] stmmac patches
Message-ID: <cover.1327394750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches add support for the STA2X11 device in the
stmmac driver. The device is a PCI-e bridge, so I need just to
add my identifiers.  The identifiers being added are already in pci_ids
of linux-next.

The second patch is a cleanup, already acked by both authors.

As for the third, I noted that there is "#ifndef MODULE" adding
__setup directives, but the module parameters already work, and I
successfully use stmmac.phy_id=1 to boot my system, so the __setup
adre just duplicates. This has not been acked by Giuseppe Cavallaro
but I offer it here nonetheless.

Alessandro Rubini (3):
  stmmac: added PCI identifiers
  stmmac: err out on second probe; use precompiled static structures
  stmmac: remove kernel cmdline parsing

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   59 ---------------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c  |   53 ++++++++++--------
 2 files changed, 29 insertions(+), 83 deletions(-)

-- 
1.7.7.2
