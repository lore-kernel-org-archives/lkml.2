Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2K3CLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:11:46 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44176 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab2K3CLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:11:45 -0500
X-Sasl-enc: TxmMvUf99zioz4kVGMgOoBSHc9FGw1MgGHQMvLq+un5x 1354241504
Date: Thu, 29 Nov 2012 18:11:43 -0800
From: Greg KH <greg@kroah.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] zram: fix invalid memory references during disk write
Message-ID: <20121130021143.GC2056@kroah.com>
References: <1354180728-1958-1-git-send-email-ngupta@vflare.org>
 <20121130003609.GA18630@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130003609.GA18630@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 09:36:09AM +0900, Minchan Kim wrote:
> Hi Greg,
> 
> I would like to tidy zram_bvec_write up but it needs more churn
> than needed to fix this bug and makes review hard. So I want you to pick up
> this patch asap because it's a candidate of stable.

It is?  How come no one said that in the patch itself?  Please read
Documentation/stable_kernel_rules.txt for how to properly include a
patch into the stable tree.

What stable trees should it go to?

thanks,

greg k-h
