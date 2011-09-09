Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055Ab1IIXMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:12:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59045 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934020Ab1IIXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:12:33 -0400
X-Sasl-enc: 0EL8qbbq1DbuRIzsHkjxpmxT/zH5r81U7SubJSxzlNgr 1315609953
Date: Fri, 9 Sep 2011 16:12:09 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] zram: Set initial disksize to some default value
Message-ID: <20110909231209.GB24604@kroah.com>
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org>
 <1315609264-13632-6-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315609264-13632-6-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 07:01:04PM -0400, Nitin Gupta wrote:
> Currently, we set initial disksize as 0, which forces
> user to write some value to corresponding zram device's
> sysfs node, before the device can be used. Now, we avoid
> this step by providing some default size initially.
> 
> To change the disksize, user must:
>  - Reset disk.
> 	Ex: echo 1 > /sys/block/zram0/reset
> (NOTE: disksize is set to the default value after reset)
> 
>  - Set new disksize.
> 	Ex: echo $((256*1024*1024)) > /sys/block/zram0/disksize

So, what tools just broke with this change?

And where is the sysfs file documentation change that should go along
with this?

greg k-h
