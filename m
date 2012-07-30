Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2G3A0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 20:26:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:36532 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab2G3A0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 20:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128254015"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>
Subject: [RFC v2 0/2] PCI-Express Non-Transparent Bridge Support 
Date: Sun, 29 Jul 2012 17:26:32 -0700
Message-Id: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Version 2 of the patch that adds support for PCI-Express Non-Transparent
Bridges in Linux.  This version incorporates the changes suggested by

Stephen Hemminger <shemminger@vyatta.com>
Greg KH <gregkh@linuxfoundation.org>
chetan loke <loke.chetan@gmail.com>
Jiri Pirko <jiri@resnulli.us>

Thanks,
Jon
