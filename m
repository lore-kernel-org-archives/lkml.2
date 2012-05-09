Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2EINvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:51:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:53838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab2EINvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:51:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150978844"
Date: Wed, 9 May 2012 16:01:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device
 support
Message-ID: <20120509140111.GD1794@sortiz-mobl>
References: <1334696962-3642-1-git-send-email-seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334696962-3642-1-git-send-email-seth.heasley@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Tue, Apr 17, 2012 at 02:09:22PM -0700, Seth Heasley wrote:
> This patch adds the Intel Centerton processor DeviceID for the Integrated Legacy Block.  The ILB provides GPIO, SMBus, and Watchdog functionality. The ILB DeviceID is defined in include/linux/pci_ids.h.
> 
Patch applied to my for-next branch, after removing this chunk (That should be
part of your watchdog driver submission):

 @@ -68,7 +69,7 @@ static struct resource wdt_sch_resource = {
  
  static struct mfd_cell tunnelcreek_cells[] = {
  	{
 -		.name = "tunnelcreek_wdt",
 +		.name = "ie6xx_wdt",
  		.num_resources = 1,
  		.resources = &wdt_sch_resource,
  	},

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
