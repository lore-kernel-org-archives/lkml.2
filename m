Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1IPSIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:08:17 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34611 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab1IPSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:08:14 -0400
X-Sasl-enc: KPVdvnCtWydGt15QPE8fe4Dz+aQPfejxoNvtYAxrYpte 1316196493
Date: Fri, 16 Sep 2011 20:03:11 +0200
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 06/20] Staging: hv: util: Properly handle util services
 in the util driver
Message-ID: <20110916180311.GB25531@kroah.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-6-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315936796-20662-6-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 10:59:42AM -0700, K. Y. Srinivasan wrote:
>  static int __init init_hyperv_utils(void)
>  {
> -	int ret;
>  	pr_info("Registering HyperV Utility Driver\n");

All of these "registering" and "unregistering" messages should be
removed, they do nothing but clutter up the logs and are pointless.  You
can find this information out any time you want by looking in sysfs
instead of trying to parse random strings out of the kernel log.

greg k-h
