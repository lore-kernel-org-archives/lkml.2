Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0ICLml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:42:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:50266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab0ICLmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:42:39 -0400
Message-ID: <4C80DF15.20100@kernel.org>
Date: Fri, 03 Sep 2010 13:42:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] block: make sure FSEQ_DATA request has the same rq_disk
 as the original
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com> <4C7FE251.2020003@kernel.org> <4C808BF8.7060402@ct.jp.nec.com> <4C80C0D6.4030405@kernel.org> <4C80CDC6.8060100@ct.jp.nec.com>
In-Reply-To: <4C80CDC6.8060100@ct.jp.nec.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 11:42:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/03/2010 12:28 PM, Kiyoshi Ueda wrote:
> Thank you for pointing it.
> Yes, the interface should also set rq->q.
> 
> About the naming of the interface, blk_set_<something> sounds
> reasonable to me.
> But does blk_set_rq_q() take request and queue as arguments?
> Then, I'm afraid we can't find bdev for bio from given queue.

Oh, right.  Maybe blk_set_rq_bdev() then?

Thanks.

-- 
tejun
