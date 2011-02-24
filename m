Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1BXSHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:07:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:6491 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab1BXSHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:07:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,219,1297065600"; 
   d="scan'208";a="606213944"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: 2nd request for review and addition of PTI implementation into kernel
Date: Thu, 24 Feb 2011 10:06:54 -0800
Message-Id: <1298570824-26085-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a second request for review and acceptance into the mainline kernel
for the Intel-Atom implementation of the MIPI P1149.7 compact JTAG
standard for mobile devices.  Complete documentation and background
has been provided in PATCH 02/12, "Kernel documentation for the PTI
feature".  PATCH 01/12 is a kernel fix to allow the PTI driver
to compile modularly; this is a fix Greg KH, Alan Cox, and Arjan
van de Ven and I talked about a while ago.  It's not techincally
related to PTI, but it is it's own separate patch so it can be
applied independent of any possible problems with the PTI submission.

Changes from last review included n_tracesink.h move, pti function
and struct renaming, and patch re-organization.

Thanks for your help and time.  Regards,
Jay

