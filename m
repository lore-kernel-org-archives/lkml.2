Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0KARua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:50:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:37211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0KARu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:50:28 -0400
Date: Mon, 1 Nov 2010 10:43:10 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@linuxonhyperv.com>
Cc: haiyangz@microsoft.com, hjanssen@microsoft.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 03/10] staging: hv: Convert camel cased struct fields
	in hv.h to lower cases
Message-ID: <20101101174310.GA12632@suse.de>
References: <1288630429-12330-1-git-send-email-haiyangz@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288630429-12330-1-git-send-email-haiyangz@linuxonhyperv.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 09:53:45AM -0700, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Convert camel cased struct fields in hv.h to lower cases
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

Why did I get two different copies of some of these patches?  Are they
different?

>  /* The one and only */
> -struct hv_context gHvContext = {
> -	.SynICInitialized	= false,
> -	.HypercallPage		= NULL,
> -	.SignalEventParam	= NULL,
> -	.SignalEventBuffer	= NULL,
> +struct hv_context g_hv_context = {

What is the "g_" for?  Why are you keeping the unneeded, and unwanted
hungarian notation around?  Please don't do that.

thanks,

greg k-h
