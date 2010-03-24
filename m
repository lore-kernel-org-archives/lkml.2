Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0CXCif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:38:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:60656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab0CXCia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:38:30 -0400
Date: Tue, 23 Mar 2010 19:29:21 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH 7/7] Documentation/ABI: for N_TI_SHARED ldisc
Message-ID: <20100324022921.GC4359@suse.de>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com> <1269376875-25940-2-git-send-email-pavan_savoy@ti.com> <1269376875-25940-3-git-send-email-pavan_savoy@ti.com> <1269376875-25940-4-git-send-email-pavan_savoy@ti.com> <1269376875-25940-5-git-send-email-pavan_savoy@ti.com> <1269376875-25940-6-git-send-email-pavan_savoy@ti.com> <1269376875-25940-7-git-send-email-pavan_savoy@ti.com> <1269376875-25940-8-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269376875-25940-8-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:41:15PM -0500, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> N_TI_SHARED creates a sysfs entry to communicate
> with the application/daemon which would want to install/
> un-install the line discipline, it's documentation
> now exists in testing/ subdirectory.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  Documentation/ABI/testing/sysfs-uim |   24 ++++++++++++++++++++++++

Again, staging drivers need to be self-contained. Please keep this in
the staging driver directory for now.

thanks,

greg k-h
