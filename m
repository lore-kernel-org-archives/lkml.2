Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1LONOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:14:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:11990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab1LONOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:14:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87652680"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC][PATCH 4/4] ahci: support hot plug when port/controller is runtime suspended
Date: Thu, 15 Dec 2011 21:12:49 +0800
Message-Id: <1323954769-3918-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com>
References: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an empty patch now :)

I use eSATA to test disk hot plug.
With previous 3 patches applied, disk hot plug does not wok
when ahci port/controller is runtime suspended.

There are 2 cases we need to handle for hot plug:

1. port suspended, controller active
   Is IRQ need to be enabled for port to detect hot plug? 

2. port suspended, controller suspended
   Will controller get a PME when hot plug happens?

I'm still investigating hot plug support.

Anyone has comment?

Thanks,
Lin Ming
