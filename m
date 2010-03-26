Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0CZNFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:05:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35887 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0CZNFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:05:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 26 Mar 2010 14:05:24 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.671196999e56464f@s5r6.in-berlin.de>
Message-ID: <tkrat.e3130c87f5d2851a@s5r6.in-berlin.de>
References: <tkrat.671196999e56464f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem update.

Clemens Ladisch (2):
      firewire: core: fw_iso_resource_manage: fix error handling
      firewire: ohci: add cycle timer quirk for the TI TSB12LV22

Stefan Richter (2):
      firewire: core: fix Model_ID in modalias
      firewire: core: align driver match with modalias

 drivers/firewire/core-device.c |  103 +++++++++++++++------------------------
 drivers/firewire/core-iso.c    |    5 +-
 drivers/firewire/ohci.c        |    4 ++
 3 files changed, 47 insertions(+), 65 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==-=- --== ==-=-
http://arcgraph.de/sr/

