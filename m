Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1EZGrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:47:20 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34886 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886Ab1EZGrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:47:18 -0400
X-Sasl-enc: XmN2acTrQHSqrwXP8Fh+JmG5KbF9tdrynaaML/EpSqcp 1306392436
Date: Wed, 25 May 2011 19:18:09 -0700
From: Greg KH <greg@kroah.com>
To: yxlraid@gmail.com
Cc: James.Bottomley@suse.de, jslaby@suse.cz, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Message-ID: <20110526021809.GA22496@kroah.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:31:47PM +0800, yxlraid@gmail.com wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
> 
> -- Add support for driver version and interrupt coalescing device attributes.

When you add a sysfs file, you must also add a Documentation/ABI file as
well.  Please do that here.

thanks,

greg k-h
