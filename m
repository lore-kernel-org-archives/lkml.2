Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1IPSIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:08:20 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59478 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932066Ab1IPSIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:08:18 -0400
X-Sasl-enc: qdsE+6+Y0Pzmth9O67uyu7eHmFQSUlgixoPXfFoHCVTu 1316196497
Date: Fri, 16 Sep 2011 20:07:08 +0200
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 0000/0020] Staging: hv: Driver cleanup
Message-ID: <20110916180708.GA32174@kroah.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315936759-20623-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 10:59:19AM -0700, K. Y. Srinivasan wrote:
> Address Greg's VmBus audit comments:
> 
> 	1) Leverage driver_data field in struct hv_vmbus_device_id to
> 	   simplify driver code.
> 
> 	2) Make the util driver conform to the Linux Driver Model.
> 
> 	3) Get rid of the ext field in struct hv_device by using the
> 	   driver specific data functionality.
> 
> 	4) Implement vmbus specific wrapper functions for setting and getting
> 	   driver specific data..
> 
> 	5) Other general cleanup.

I applied 17 of these (i.e. the ones I didn't comment on.)

greg k-h
