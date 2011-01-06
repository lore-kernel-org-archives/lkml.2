Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1AFF5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 00:57:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56124 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab1AFF5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 00:57:09 -0500
Date: Thu, 6 Jan 2011 05:56:48 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (drm
 tree related)
In-Reply-To: <20110106160309.7c8e0d16.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1101060556170.15019@skynet.skynet.ie>
References: <20110106160309.7c8e0d16.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/gpu/drm/radeon/radeon_device.c: In function 'radeon_device_init':
> drivers/gpu/drm/radeon/radeon_device.c:783: error: too many arguments to function 'vga_switcheroo_register_client'

Thanks, noticed it myself this morning, fixed pushed to my tree so should 
be good tomorrow.

Dave.
