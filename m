Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab0JAMvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:51:51 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58711 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559Ab0JAMvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:51:49 -0400
Message-ID: <4CA5D964.4060609@kernel.dk>
Date: Fri, 01 Oct 2010 14:51:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] blkio-throttle: Fix linux-next compilation failure on
 i386
References: <20100928193446.GE8950@redhat.com>
In-Reply-To: <20100928193446.GE8950@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-28 21:34, Vivek Goyal wrote:
> Hi Jens,
> 
> One more fix for throttling logic. After this fix I realized that there is
> potential for integer overflow in my calculations. I need to figure out
> how to take care of these overflow situations and will post a patch for
> that later.

I have applied this and the previous patchset of 4 patches, thanks.

-- 
Jens Axboe

