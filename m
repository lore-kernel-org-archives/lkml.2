Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2K2Vil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:38:41 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34143 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811Ab2K2Vik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:38:40 -0500
X-Sasl-enc: J2wM5M5AFjs+8vG2Fw2RVNairZmWPFFuiGgd2ns9BUGv 1354225119
Date: Thu, 29 Nov 2012 13:38:38 -0800
From: Greg KH <greg@kroah.com>
To: Anthony Foiani <tkil@scrye.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] v3.0.x: mtd: check partition count not partition
 array pointer
Message-ID: <20121129213838.GA20660@kroah.com>
References: <gpq3oh9on.fsf@dworkin.scrye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gpq3oh9on.fsf@dworkin.scrye.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 11:48:24PM -0700, Anthony Foiani wrote:
> 
> mtd: check partition count not partition array pointer
> 
> The documentation claims that "nr_parts" is the determining factor,
> while the code originally tested whether "parts" is non-null.
> 
> In at least one driver (fsl_elbc_nand), parts is never initialized to
> 0; even though nr_parts is correctly 0, add_mtd_partitions still tries
> to create 0 partitions.)
> 
> Make the code adhere to the documentation.
> 
> A quick scan of all uses in the 3.0.51 kernel show that they correctly
> rely on nr_parts rather than parts.
> 
> The current kernel has retired this function; I have not examined its
> replacement to see if it has the same issue.
> 
> Signed-Off-By: Anthony Foiani <anthony.foiani@gmail.com>
> ---
>  drivers/mtd/mtdcore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
