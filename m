Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0I2RtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:49:13 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:50779 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586Ab0I2RtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:49:12 -0400
Message-ID: <4CA37C11.2040603@opengridcomputing.com>
Date: Wed, 29 Sep 2010 12:49:05 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int>	<adawrq431sr.fsf@cisco.com> <4CA37715.4020302@opengridcomputing.com> <adask0s30sr.fsf@cisco.com>
In-Reply-To: <adask0s30sr.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 12:41 PM, Roland Dreier wrote:
>   >  I assume you mean debugs_read()...Like this?
>
> Sorry, yeah, was looking at the old code.  But yes, that code seems a
> lot simpler.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    

I'll change it, test it,  and send you a patch.

