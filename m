Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2GNM6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:58:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18303 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2GNM6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:58:54 -0400
Date: Sat, 14 Jul 2012 15:58:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Austin Robinson <austin.rbsn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: ashmem: Replaces printk with pr_err
 and pr_info
Message-ID: <20120714125840.GI6056@mwanda>
References: <1342268914-4547-1-git-send-email-austin.rbsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342268914-4547-1-git-send-email-austin.rbsn@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 08:28:34AM -0400, Austin Robinson wrote:
> In several instances in ashmem.c, printk(KERN_INFO... and printk{KERN_ERR... were being
> used. This replaces those with the preferred pr_err and pr_info, which removes
> style-related warnings.
> 

Someone already did this.  You should be working against linux-next.

regards,
dan carpenter

