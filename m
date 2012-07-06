Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab2GFOYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:24:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48824 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756483Ab2GFOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:24:39 -0400
Date: Fri, 6 Jul 2012 10:24:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: James Bottomley <JBottomley@Parallels.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] [SCSI] scsi_pm: set device runtime state before parent
 suspended
In-Reply-To: <1341547617.6401.1.camel@chief-river-32>
Message-ID: <Pine.LNX.4.44L0.1207061023350.28821-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Lin Ming wrote:

> There is a race in scsi_bus_resume_common when set device's runtime
> state to active after pm_runtime_put_sync(dev->parent).
> 
> Parent device may have been suspended so pm_runtime_set_active(dev) will
> fail with -EBUSY.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

