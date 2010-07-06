Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0GFHC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:02:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:42419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0GFHC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:02:27 -0400
Message-ID: <4C32D4BE.9030005@kernel.org>
Date: Tue, 06 Jul 2010 09:01:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/35] ivtv: use kthread_worker instead of workqueue
References: <1277759063-24607-1-git-send-email-tj@kernel.org>	 <1277759063-24607-3-git-send-email-tj@kernel.org> <1278349860.2229.9.camel@localhost>
In-Reply-To: <1278349860.2229.9.camel@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Jul 2010 07:01:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 07:11 PM, Andy Walls wrote:
> Assuming the new kthread_worker implementation is OK, this change for
> ivtv looks good.
> 
> Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> Acked-by: Andy Walls <awalls@md.metrocast.net>

May I route this patch through wq branch?  As it's not clear how this
whole patchset will end up, I think it would be better to keep things
isolated in this branch.

Thank you.

-- 
tejun
