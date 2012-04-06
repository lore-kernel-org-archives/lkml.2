Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2DFBKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 21:10:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41518 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757012Ab2DFBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 21:10:41 -0400
X-Sasl-enc: BCVSadN7v1OunYEf3gGzPyXjfnUFKDyzPBYJbYELjKsM 1333674639
Date: Thu, 5 Apr 2012 18:10:37 -0700
From: Greg KH <greg@kroah.com>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/5] mtip32xx: Add new sysfs entry 'status' and fix
 restart port
Message-ID: <20120406011037.GA25892@kroah.com>
References: <4F7E07DC.50909@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7E07DC.50909@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 02:00:12PM -0700, Asai Thambi S P wrote:
> 
> * Add support for detecting the following device status
> 	- write protect
> 	- over temp (thermal shutdown)
> * New sysfs entry 'status' created for this device,  possible values - online, write_protect, thermal_shutdown

All new (and existing) sysfs files must be documented in
Documentation/ABI/ please do so for these new ones when you add them to
the kernel.

thanks,

greg k-h
