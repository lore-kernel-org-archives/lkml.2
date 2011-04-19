Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1DSW6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:58:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:32614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1DSW6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,241,1301900400"; 
   d="scan'208";a="735757817"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: 3rd request for review & addition of PTI/n_trace implementation into kernel
Date: Tue, 19 Apr 2011 15:58:05 -0700
Message-Id: <1303253889-10074-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for a long delay between submission attempts- this is the 3rd request
for review and acceptance into the mainline kernel for the Intel-Atom
implementation of the MIPI P1149.7 compact JTAG
standard for mobile devices.  Complete documentation and background
has been provided in PATCH 02/12, "Kernel documentation for the PTI
feature".  PATCH 01/12 is a kernel fix to allow the PTI driver
to compile modularly; this is a fix Greg KH, Alan Cox, and Arjan
van de Ven and I talked about a while ago.  It's not techincally
related to PTI, but it is it's own separate patch so it can be
applied independent of any possible problems with the PTI submission.

Changes/fixes from last review include:
-lock acquire and release same ordering in n_tracesink and n_tracerouter
-variable renaming in pti.c
-elimination of one variable not used in pti.c
-patch groups submissions in logical, independent chunks instead one
 file per patch.
-use of linux-next instead of linux-stable for patch base
-Kconfig descriptions appearing in patch descriptions for
 pti and n_tracesink/n_tracerouter, as requested.

Thanks for your help and time. Regards,
J Freyensee

From: james_p_freyensee@linux.intel.com
Subject: 3rd request for review & addition of PTI/n_trace implementation into kernel
In-Reply-To: james_p_freyensee@linux.intel.com

