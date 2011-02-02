Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1BBUww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:52:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:57533 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1BBUwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:52:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,415,1291622400"; 
   d="scan'208";a="883745636"
From: Russ Gorby <russ.gorby@intel.com>
To: David Brownell <dbrownell@users.sourceforge.net> (maintainer:SPI
	SUBSYSTEM),
        Grant Likely <grant.likely@secretlab.ca> (maintainer:SPI SUBSYSTEM),
        Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:1/1=100%),
        linux-kernel@vger.kernel.org (open list),
        spi-devel-general@lists.sourceforge.net (open list:SPI SUBSYSTEM)
Subject: [PATCH 0/1] ifx6x60 expanded platform data patch: 01/26/2011
Date: Wed,  2 Feb 2011 12:56:57 -0800
Message-Id: <1296680218-2693-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/1] ifx6x60 expanded platform data patch: 01/26/2011>
References: <[PATCH 0/1] ifx6x60 expanded platform data patch: 01/26/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I am sending a patch for the ifx6x60 driver to expand the
information available via the platform data structure.
I'd like these to be considred for inclusion into the Linux Kernel.

Additional patches will follow that will depend on these changes
so I'd like to iron these  out first.

Patches were made against the repo:
http://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
as of 01/26/2011
