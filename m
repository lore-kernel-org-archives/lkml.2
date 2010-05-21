Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0EUNSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab0EUNR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:17:59 -0400
Date: Fri, 21 May 2010 09:17:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] io-controller: Add new interfaces to trace
	backlogged group status
Message-ID: <20100521131751.GA15302@redhat.com>
References: <4BF64712.1070500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF64712.1070500@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 04:40:50PM +0800, Gui Jianfeng wrote:
> Hi,
> 
> This series implements three new interfaces to keep track of tranferred bytes,
> elapsing time and io rate since group getting backlogged. If the group dequeues
> from service tree, these three interfaces will reset and shows zero.

Hi Gui,

Can you give some details regarding how this functionality is useful? Why
would somebody be interested in only in stats of till group was
backlogged and not in total stats?

Groups can come and go so fast and these stats will reset so many times
that I am not able to visualize how these stats will be useful.

Thanks
Vivek

> 
> Thanks
> Gui
