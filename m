Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937Ab1IIUrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:47:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42997 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759922Ab1IIUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:04 -0400
X-Sasl-enc: TkUQvL8zXbODmgvLhB7fE9LX+XAIdzniIbmGvV+AUyYM 1315601223
Date: Fri, 9 Sep 2011 13:30:19 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5 resend] Fix sparse warnings
Message-ID: <20110909203019.GA19140@kroah.com>
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
 <1315445357-14338-2-git-send-email-ngupta@vflare.org>
 <4E6A4AA7.5050004@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6A4AA7.5050004@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 01:19:35PM -0400, Nitin Gupta wrote:
> Fixes sparse warning:
> zram_drv.c:666:6: warning: symbol 'zram_slot_free_notify' was not
> declared. Should it be static?
> 
> Also, max_zpage_size is now size_t just to be consistent with data-type
> of other variables maintaining sizes of various kinds.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  drivers/staging/zram/zram_drv.c |    3 ++-
>  drivers/staging/zram/zram_drv.h |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)

Close, but can you please resend the series with a proper Subject: line
that shows what subsystem/driver this is for?  I explained how to do
this properly in a prior email.

thanks,

greg k-h
