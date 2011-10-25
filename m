Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1JYPfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:35:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38588 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1JYPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:35:45 -0400
Date: Tue, 25 Oct 2011 08:35:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] lib: devres: add convenience function to remap a
 resource
Message-ID: <20111025153538.GA13012@google.com>
References: <1319548607-28427-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319548607-28427-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 03:16:47PM +0200, Wolfram Sang wrote:
> Almost every platform_driver does the three steps get_resource,
> request_mem_region, ioremap. This does not only lead to a lot of code
> duplication, but also a huge number of similar error strings and
> inconsistent error codes on failure. So, introduce a helper function
> which simplifies remapping a resource and make it hard to do something
> wrong and add documentation for it.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Greg KH <gregkh@suse.de>

 Acked-by: Tejun Heo <tj@kernel.org>

Greg, can you please take this one?

Thank you.

-- 
tejun
