Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1KKC0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:26:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:59329 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab1KKCZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:25:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="73849432"
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
From: Lin Ming <ming.m.lin@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20111110153132.GD27258@google.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
	 <20111110153036.GC27258@google.com>  <20111110153132.GD27258@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 10:25:56 +0800
Message-ID: <1320978356.32515.11.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 23:31 +0800, Tejun Heo wrote:
> Ooh, by the way, can you please write more about how you tested it?

I have 2 disks installed.
sda installs the OS. I use sdb to test ata port runtime PM.

# set "auto" to enable disk runtime PM
# echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/power/control

mount sdb1 causes ata port resume

umount sdb1 causes ata port suspend

> 
> Thanks.
> 


