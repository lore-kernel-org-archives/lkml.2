Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062Ab0GUCM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 22:12:27 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44854 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762002Ab0GUCM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 22:12:26 -0400
Message-ID: <4C46577F.7050909@kernel.dk>
Date: Tue, 20 Jul 2010 20:12:15 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/16] xen/blkfront: various bugfixes and patches for
 blkfront
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 02:42 PM, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Hi Jens,
> 
> This series has various updates to blkfront, including:
>  - support for dynamic device resizing
>  - bugfixes for device hotplug
>  - various races and bugs fixed
> 
> It can be pulled from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/blkfront

They don't apply cleanly to the for-2.6.36 branch, it fails at patch 2:

patching file drivers/block/xen-blkfront.c
Hunk #1 succeeded at 105 (offset 1 line).
Hunk #2 succeeded at 143 (offset 1 line).
Hunk #9 FAILED at 1080.
Hunk #10 succeeded at 1106 with fuzz 1 (offset 5 lines).
1 out of 10 hunks FAILED -- saving rejects to file drivers/block/xen-blkfront.c.rej

-- 
Jens Axboe

