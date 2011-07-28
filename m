Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1G1KSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:18:02 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52635 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1G1KSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:18:00 -0400
Date: Thu, 28 Jul 2011 12:17:55 +0200
From: Tejun Heo <tj@kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: add management interface for on-demand device
 allocation
Message-ID: <20110728101755.GH2622@htj.dyndns.org>
References: <1311681033.1325.4.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311681033.1325.4.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kay.

On Tue, Jul 26, 2011 at 01:50:30PM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: loop: add management interface for on-demand device allocation
> 
> Loop devices today have a fixed pre-allocated number of usually 8.
> The number can only be changed at init time. To find a free device
> to use, /dev/loop%i needs to be scanned and all devices need to be
> opened.

It generally looks good to me but I really hope it were split into
multiple patches.  I think it's a bit too big and doing too many
different things.  Can you please split it up?

> +static int loop_lookup(struct loop_device **lo, int nr);
> +static int loop_add(struct loop_device **lo, int nr);

Also, can't these return loop_device * and ERR_PTR() value on errors?

Thanks.

-- 
tejun
