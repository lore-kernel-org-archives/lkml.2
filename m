Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0CVVh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:37:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab0CVVh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:37:26 -0400
Date: Mon, 22 Mar 2010 14:36:29 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100322213629.GD420@suse.de>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com> <1269292756-7469-2-git-send-email-pavan_savoy@ti.com> <1269292756-7469-3-git-send-email-pavan_savoy@ti.com> <1269292756-7469-4-git-send-email-pavan_savoy@ti.com> <1269292756-7469-5-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269292756-7469-5-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 04:19:14PM -0500, pavan_savoy@ti.com wrote:
> +/* structures specific for sysfs entries */
> +static struct kobj_attribute pid_attr =
> +__ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
> +
> +static struct kobj_attribute list_protocols =
> +__ATTR(protocols, 0444, (void *)show_list, NULL);

As you are creating sysfs attributes, you have to have
Documentation/ABI/ updates as well.  Please include them so we can see
what you are trying to do here.

And why "raw" attributes and not device ones?

thanks,

greg k-h
