Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab2IESrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:47:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2IESrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:47:15 -0400
Date: Wed, 5 Sep 2012 20:47:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ak@linux.intel.com, tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, ananth@in.ibm.com
Subject: Re: [PATCH] [mcelog] Start using the new sysfs tunables location
Message-ID: <20120905184708.GC16230@one.firstfloor.org>
References: <20120905102156.9423.27806.stgit@localhost.localdomain> <20120905103237.9726.56131.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905103237.9726.56131.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 04:02:37PM +0530, Naveen N. Rao wrote:
> All the current mce tunables are now available under
> /sys/devices/system/machinecheck. Start using this new location, but fall back
> to the older per-cpu location so that we continue working with older kernels.

Who did that change in the kernel?

That breaks Linus rule that the kernel should not break userland.
Kernel needs to fix that.

-Andi
