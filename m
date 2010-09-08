Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0IHA0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:26:36 -0400
Received: from kroah.org ([198.145.64.141]:51498 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab0IHAZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:25:33 -0400
Date: Tue, 7 Sep 2010 17:00:04 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, device modules fixes
Message-ID: <20100908000004.GF12823@kroah.com>
References: <1283888414.7250.24.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283888414.7250.24.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 12:40:14PM -0700, David Cross wrote:
> This patch makes minor fixes to the device module for locking issues,
> as well as some changes for the HAL/Kconfig changes made in a separate
> patch. Please let me know if there are issues or concerns with this
> patch.

Again, one thing per patch please.  It's getting better, but I think you
can still split things up here.

Remember your old math professor, "Show your every step of your work."

thanks,

greg k-h
