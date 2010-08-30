Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0H3R2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:28:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:43074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab0H3R2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:28:12 -0400
Message-ID: <4C7BEA30.1090000@kernel.org>
Date: Mon, 30 Aug 2010 19:28:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
CC: OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        linux-kernel@vger.kernel.org, Hu Tao <taohu@motorola.com>,
        jaxboe@fusionio.com, torvalds@osdl.org
Subject: Re: [PATCH v6] scatterlist: prevent invalid free when alloc fails
References: <4C7BD8BE.7050600@kernel.org> <20100830165022.96032603843@il93ubuntu.localdomain>
In-Reply-To: <20100830165022.96032603843@il93ubuntu.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 17:28:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 06:19 PM, Jeffrey Carlyle wrote:
> When alloc fails, free_table is being called. Depending on the number of
> bytes requested, we determine if we are going to call _get_free_page()
> or kmalloc(). When alloc fails, our math is wrong (due to sg_size - 1),
> and the last buffer is wrongfully assumed to have been allocated by
> kmalloc. Hence, kfree gets called and a panic occurs.
> 
> Signed-off-by: Jeffrey Carlyle <jeff.carlyle@motorola.com>
> Signed-off-by: Olusanya Soyannwo <c23746@motorola.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <jaxboe@fusionio.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks. :-)

-- 
tejun
