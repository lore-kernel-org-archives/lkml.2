Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1HCPx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 11:53:57 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58953 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639Ab1HCPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:53:51 -0400
X-Sasl-enc: w5GxGxWX9MyKUE6NVNRwXftHG6H7YOBh0M+INY6h9mfQ 1312386830
Date: Wed, 3 Aug 2011 08:39:37 -0700
From: Greg KH <greg@kroah.com>
To: wei_wang@realsil.com.cn
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rts_pstor:modify thread synchronization flow
Message-ID: <20110803153937.GB3479@kroah.com>
References: <1312358425-8442-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312358425-8442-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 04:00:25PM +0800, wei_wang@realsil.com.cn wrote:
> From: wwang <wei_wang@realsil.com.cn>
> 
> Using different completion variables to synchronize different kernel threads
> 
> Signed-off-by: wwang <wei_wang@realsil.com.cn>

Is this fixing a bug that is seen now, or is this just a nice "cleanup"
patch that can wait for the 3.2 kernel release?

thanks,

greg k-h
