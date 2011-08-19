Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1HSNkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:40:09 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:35970 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab1HSNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:40:03 -0400
Date: Fri, 19 Aug 2011 16:37:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 68/75] hv: netvsc: convert to SKB paged frag API.
Message-ID: <20110819133739.GA3715@shale.localdomain>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
 <1313760467-8598-68-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313760467-8598-68-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:27:40PM +0100, Ian Campbell wrote:
>  	/* usually there's just one frag */
> -	skb_frag_set_page(skb, 0, gl->frags[0].page);
> +	skb_frag_set_page(skb, 0, gl->frags[0].page.p);	/* XXX */

There are bunch of new /* XXX */ comments.  What are they for?

regards,
dan carpenter

