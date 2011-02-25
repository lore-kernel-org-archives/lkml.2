Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1BYSC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:02:59 -0500
Received: from kroah.org ([198.145.64.141]:34288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab1BYSCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:02:52 -0500
Date: Fri, 25 Feb 2011 10:00:31 -0800
From: Greg KH <greg@kroah.com>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 10/10] n_tracerouter and n_tracesink compile
 configurations.
Message-ID: <20110225180031.GB17072@kroah.com>
References: <james_p_freyensee@linux.intel.com>
 <1298570824-26085-11-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298570824-26085-11-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:07:04AM -0800, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This patch allows n_tracerouter and n_tracesink to be compiled and
> configured in the Linux kernel.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  drivers/char/Kconfig |   32 ++++++++++++++++++++++++++++++++

Why drivers/char/Kconfig?  This should be in drivers/tty/Kconfig, right?

Yes, this is a recent change, see the linux-next tree for the addition
of this file :)

thanks,

greg k-h
