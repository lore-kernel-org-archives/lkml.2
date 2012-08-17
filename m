Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2HQNZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:25:40 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50732 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287Ab2HQNZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:25:33 -0400
X-Sasl-enc: qE2vmNe/t7lLRVZDNbYiuUOozTg1K0Z32b8LNI0nC2bh 1345209932
Date: Fri, 17 Aug 2012 06:25:31 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120817132531.GD28980@kroah.com>
References: <20120817140123.56bf158c14abc8fc0147bd67@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817140123.56bf158c14abc8fc0147bd67@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 02:01:23PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "device_pm_lock" [drivers/base/firmware_class.ko] undefined!
> ERROR: "dpm_list" [drivers/base/firmware_class.ko] undefined!
> ERROR: "device_pm_unlock" [drivers/base/firmware_class.ko] undefined!
> 
> Caused by commit 37276a51f803 ("firmware: introduce
> device_cache/uncache_fw_images").

Thanks, known bug, Ming is working on resolving the issue.

greg k-h
