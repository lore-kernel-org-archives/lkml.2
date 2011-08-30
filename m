Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1H3Pzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:55:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34408 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1H3Pzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:55:46 -0400
Date: Tue, 30 Aug 2011 18:53:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 10/59] Staging: hv: util: Make hv_utils a vmbus device
 driver
Message-ID: <20110830155323.GT3705@shale.localdomain>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-10-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314290965-2698-10-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 09:48:36AM -0700, K. Y. Srinivasan wrote:
> +	util_drv.driver.name = driver_name;
> +
> +	return vmbus_child_driver_register(&util_drv.driver);

We should free the allocations if vmbus_child_driver_register() fails.

regards,
dan carpenter

