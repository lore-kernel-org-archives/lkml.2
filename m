Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408Ab2B1Qyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:54:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965834Ab2B1Qyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:54:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.241.70 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Tue, 28 Feb 2012 08:54:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Autif Khan <autifk@gmail.com>
Cc: rusty@rustcorp.com.au, jhovold@gmail.com, stern@rowland.harvard.edu,
        mchehab@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers: net: usb: sierra_net - upgrade to 3.2
Message-ID: <20120228165417.GD11133@kroah.com>
References: <1330447230-5811-1-git-send-email-autifk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330447230-5811-1-git-send-email-autifk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:40:30AM -0500, Autif Khan wrote:
> driver was upgraded from 2.0 to 3.2
> source of the driver at the time of this change:
> http://www.sierrawireless.com/resources/support/drivers/linux/v3.2_1740_kernel-3.0.directIP.tar
> 
> The driver compiles (monolithic and module)
> I have not tested it on any device

If you haven't tested it, why did you need it to be updated?  :)

Same comments for this one as the 1/3 patch, sorry.

greg k-h
