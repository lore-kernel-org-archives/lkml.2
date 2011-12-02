Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab1LBP3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:29:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60436 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756830Ab1LBP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:29:33 -0500
Date: Fri, 2 Dec 2011 10:29:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH v4 0/6] ata port runtime power management support
In-Reply-To: <1322804150.344.3.camel@minggr>
Message-ID: <Pine.LNX.4.44L0.1112021028540.1420-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Lin Ming wrote:

> Hi Alan,
> 
> You have signed Patch 3: [SCSI] check runtime PM status in system PM.
> 
> How about the other two SCSI patches?
> 
> Patch 2: [SCSI] add flag to skip the runtime PM calls on the host
> Patch 4: [SCSI] sd: check runtime PM status in sd_shutdown

For both patch 2 and patch 4:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

