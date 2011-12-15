Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab1LOTD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:03:27 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59350 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759358Ab1LOTD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:03:26 -0500
X-Sasl-enc: zsYxXFudOTjxRFovNVZ1XfC5nJsi0Tm0I8fyLiq3xn1W 1323975804
Date: Thu, 15 Dec 2011 10:57:15 -0800
From: Greg KH <greg@kroah.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH] misc: max8997-muic: remove sysfs attribute
Message-ID: <20111215185715.GC18791@kroah.com>
References: <1323940847-31340-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323940847-31340-1-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 06:20:47PM +0900, Donggeun Kim wrote:
> The 'switch' sysfs attribute is used for
> showing and setting the switch state of the device.
> However, setting it from the userspace focibly is not appropriate.
> And showing the state can be handled from
> other places (e.g. external connector) in a unified manner.
> This patch removes the sysfs attribute.
> Plus, uevent messages for interrupts are also removed.
> 
> The initial max8997-muic driver is merged at:
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

