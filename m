Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1EBPov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:44:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:37310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab1EBPor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:44:47 -0400
Date: Mon, 2 May 2011 08:39:02 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: wanlong.gao@gmail.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] KernelDoc:Add the device driver-model structures to
 kerneldoc
Message-ID: <20110502153902.GA8098@suse.de>
References: <1304348681-24950-1-git-send-email-wanlong.gao@gmail.com>
 <1304348681-24950-2-git-send-email-wanlong.gao@gmail.com>
 <20110502082609.77b23473.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502082609.77b23473.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 08:26:09AM -0700, Randy Dunlap wrote:
> On Mon,  2 May 2011 23:04:40 +0800 wanlong.gao@gmail.com wrote:
> 
> > From: Wanlong Gao <wanlong.gao@gmail.com>
> > 
> > Add the comment the structure bus_type, device_driver, device,
> > class for generating the driver-model kerneldoc.
> 
> Warning: trailing whitespace in lines 66,478,498,499 of include/linux/device.h
> 
> Other than that:
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks.
> 
> Greg, do you want to merge this or should I?

Please don't, I have some issues with it that I will respond to in a
minute.

thanks,

greg k-h
