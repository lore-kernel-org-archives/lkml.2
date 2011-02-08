Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab1BHTfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:35:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:43704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab1BHTfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:35:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,443,1291622400"; 
   d="scan'208";a="705461250"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: Resend: Request for review and addition of PTI implementation into kernel
Date: Tue,  8 Feb 2011 11:34:45 -0800
Message-Id: <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize if this winds up being a duplicate; I believe yesterday's email 
attempt never made it out completely.

This is a request for review and acceptance into the mainline kernel
for the Intel-Atom implementation of the MIPI P1149.7 compact JTAG
standard for mobile devices.  Complete documentation and background
has been provided in PATCH 02/12, "Kernel documentation for the PTI
feature".  PATCH 01/12 is a kernel fix to allow the PTI driver
to compile modularly; this is a fix Greg KH, Alan Cox, and Arjan
van de Ven and I talked about a while ago.  It's not techincally
related to PTI, but it is it's own separate patch so it can be
applied independent of any possible problems with the PTI submission.

Thanks for your help and time.  Regards,
J Freyensee

