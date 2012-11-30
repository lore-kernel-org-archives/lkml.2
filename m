Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2K3CNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:13:39 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45690 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450Ab2K3CNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:13:37 -0500
X-Sasl-enc: 9umvH3PLtoF/9LoiIj1CTlW78ogHBiLM1sUyX5ay8uQM 1354241616
Date: Thu, 29 Nov 2012 18:13:35 -0800
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
Message-ID: <20121130021335.GD2056@kroah.com>
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

Ok, I have way too many different, and competing, zram patches in my
inbox right now.

So I'm just going to delete them all, and ask Nitin to resend them all
so I know what is going on here.

Nitin, is that ok?

thanks,

greg k-h
