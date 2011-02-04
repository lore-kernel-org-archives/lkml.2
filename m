Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1BDAEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:04:02 -0500
Received: from kroah.org ([198.145.64.141]:37913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1BDADz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:03:55 -0500
Date: Thu, 3 Feb 2011 16:03:30 -0800
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2/7] drivers:misc: ti-st: move from rfkill to sysfs
Message-ID: <20110204000330.GA20634@kroah.com>
References: <1296644448-29667-1-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-2-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-3-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296644448-29667-3-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 05:00:43AM -0600, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> The communication between ST KIM and UIM was interfaced
> over the /dev/rfkill device node.
> Move the interface to a simpler less abusive sysfs entry
> mechanism.

That's nice, but you need to document all sysfs files in
Documentation/ABI/

Can you please do that in this patch and resend the series?

thanks,

greg k-h
