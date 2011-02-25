Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab1BYSC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:02:58 -0500
Received: from kroah.org ([198.145.64.141]:34292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab1BYSCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:02:53 -0500
Date: Fri, 25 Feb 2011 10:01:00 -0800
From: Greg KH <greg@kroah.com>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 10/10] n_tracerouter and n_tracesink compile
 configurations.
Message-ID: <20110225180100.GC17072@kroah.com>
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
> --- a/drivers/tty/Makefile
> +++ b/drivers/tty/Makefile
> @@ -7,5 +7,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
>  obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
>  obj-$(CONFIG_N_GSM)		+= n_gsm.o
>  obj-$(CONFIG_R3964)		+= n_r3964.o
> +obj-$(CONFIG_TRACE_ROUTER)      += n_tracerouter.o
> +obj-$(CONFIG_TRACE_SINK)        += n_tracesink.o

Please follow the standards of this file and use tabs :(

