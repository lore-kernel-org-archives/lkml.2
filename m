Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1CBNq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:46:59 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49833 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab1CBNq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:46:58 -0500
Message-ID: <4D6E4A46.1040709@kernel.dk>
Date: Wed, 02 Mar 2011 08:46:46 -0500
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mike Snitzer <snitzer@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v2.6.38-rc5 2/2] block: blk-flush shouldn't call  directly
 into q->request_fn() __blk_run_queue()
References: <20110217111511.GQ19830@htj.dyndns.org> <20110217111619.GR19830@htj.dyndns.org> <AANLkTi=rPKN25yZTziv1dz=Ke0db8ZOwUgKFNzWn9+x7@mail.gmail.com> <20110218094903.GF21209@htj.dyndns.org>
In-Reply-To: <20110218094903.GF21209@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-18 04:49, Tejun Heo wrote:
> On Thu, Feb 17, 2011 at 10:01:51AM -0500, Mike Snitzer wrote:
>> Hi Tejun,
>>
>> On Thu, Feb 17, 2011 at 6:16 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>>> Jens, this is applicable to v2.6.37 and 38.  The new implementation
>>> for 39 would need similar fix but I couldn't find where the tree is.
>>> Which branch is it?
>>
>> for-2.6.39/core
> 
> Right, thanks.  Jens, after you apply the two fixes for 2.6.38, I can
> create a merge branch for for-2.6.39/core which you can pull.  Would
> that work for you?

Thanks, that would be great. I'm applying them now.

-- 
Jens Axboe

