Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2FWPSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 11:18:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18560 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2FWPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 11:18:51 -0400
Date: Sat, 23 Jun 2012 18:18:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-mm-cc@laptop.org, linux-kernel@vger.kernel.org,
        ngupta@vflare.org
Subject: Re: [PATCH 2/2] staging: zram: Remove useless struct zobj_header
Message-ID: <20120623151819.GE5333@mwanda>
References: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
 <1340249565-29404-3-git-send-email-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340249565-29404-3-git-send-email-marcos.souza.org@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 12:32:45AM -0300, Marcos Paulo de Souza wrote:
> The struct zobj_header has no members, so the sizeof(struct zobj_header *)
> always returns zero. For this reason we are removing this useless struct.
> 

I've been out for the past few days and I'm slowly catching up.  If
you want you could update this comment as well:

drivers/staging/zram/zram_drv.h
    40  /*
    41   * NOTE: max_zpage_size must be less than or equal to:
    42   *   ZS_MAX_ALLOC_SIZE - sizeof(struct zobj_header)
    43   * otherwise, xv_malloc() would always return failure.
    44   */

regards,
dan carpenter

