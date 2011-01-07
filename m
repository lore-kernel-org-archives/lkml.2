Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1AGRdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:33:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:58796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab1AGRdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:33:08 -0500
Date: Fri, 7 Jan 2011 09:31:39 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Removed unneeded call to
 netif_stop_queue() in hv_netvsc
Message-ID: <20110107173139.GA12343@suse.de>
References: <1294421139-18657-1-git-send-email-hjanssen@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294421139-18657-1-git-send-email-hjanssen@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 09:25:39AM -0800, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Removed the call to netif_stop_queue() in netvsc_probe() as
> the queue is not initialized at that point and further call
> to it after queue initialization is really not necessary.
> 
> This change was prompted after an upstream change went into 
> 2.6.37 (netif_tx_stop_queue) that now checks if netif_stop_queue
> is called before register with netdev is done.
> 
> This will eliminate the warning message to the log when hv_netvsc
> driver starts up.
> 
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

What kernel is this needed for, .37?  .38?  older than .37?

thanks,

greg k-h
