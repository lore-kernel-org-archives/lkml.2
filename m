Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2CGML1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662Ab2CGMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] Post EDAC core fix patches
Date: Wed,  7 Mar 2012 09:11:12 -0300
Message-Id: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addresses some other stuff that requires cleaning, fixes or improvements after 
applying the proper support for FB-DIMM and for the modern Intel DDR2/DDR3 
memory controllers changeset.

Mauro Carvalho Chehab (6):
  edac: Initialize the dimm label with the known information
  edac_mc_sysfs: don't create inactive errcount sysfs nodes
  i5000_edac: Fix the logic that retrieves memory information
  edac: add a sysfs node that stores the max possible memory location
  edac: Call the sysfs nodes as "rank" instead of "dimm" if chip select
    is used
  i5400_edac: improve debug messages to better represent the filled
    memory

 drivers/edac/edac_mc.c       |   21 +++++-
 drivers/edac/edac_mc_sysfs.c |  147 +++++++++++++++++++++++++++++------------
 drivers/edac/i5000_edac.c    |  150 ++++++++++++++++++++++--------------------
 drivers/edac/i5400_edac.c    |   15 ++++-
 4 files changed, 216 insertions(+), 117 deletions(-)

-- 
1.7.8

