Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1LSRpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:45:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:34152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1LSRpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:45:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97983815"
Date: Mon, 19 Dec 2011 18:50:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, greg@kroah.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH] misc: max8997-muic: remove sysfs attribute
Message-ID: <20111219175020.GT11800@sortiz-mobl>
References: <1323940847-31340-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323940847-31340-1-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Donggeun,

On Thu, Dec 15, 2011 at 06:20:47PM +0900, Donggeun Kim wrote:
> The 'switch' sysfs attribute is used for
> showing and setting the switch state of the device.
> However, setting it from the userspace focibly is not appropriate.
> And showing the state can be handled from
> other places (e.g. external connector) in a unified manner.
> This patch removes the sysfs attribute.
> Plus, uevent messages for interrupts are also removed.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
