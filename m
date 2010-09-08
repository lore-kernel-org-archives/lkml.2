Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0IHAZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:25:39 -0400
Received: from kroah.org ([198.145.64.141]:51500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab0IHAZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:25:36 -0400
Date: Tue, 7 Sep 2010 17:00:21 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, cyasgadget fixes
Message-ID: <20100908000021.GG12823@kroah.com>
References: <1283888647.7250.28.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283888647.7250.28.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 12:44:07PM -0700, David Cross wrote:
> This patch contains update to the gadget driver, some of which are based
> on feedback from the Linux community concerning the usage of fat_get_block.
> This function call has since been removed along with all file system 
> specific calls.
> It also contains some fixes for locking issues.
> Please let me know if there are issues or concerns with this patch.

Again, one patch per change.

thanks,

greg k-h
