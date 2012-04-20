Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2DTTIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:08:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52132 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab2DTTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:08:45 -0400
Message-ID: <4F91B433.2070209@kernel.dk>
Date: Fri, 20 Apr 2012 21:08:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: per-queue policy activation, take#2
References: <1334347895-6268-1-git-send-email-tj@kernel.org> <20120420080943.GG7505@kernel.dk> <4F91503D.2060402@kernel.dk> <20120420171742.GC32324@google.com>
In-Reply-To: <20120420171742.GC32324@google.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-20 19:17, Tejun Heo wrote:
> Hello, Jens.
> 
> On Fri, Apr 20, 2012 at 02:02:05PM +0200, Jens Axboe wrote:
>> Tejun, everything merged in cleanly. A boot test didn't not go so well,
>> I'm afraid. It complains about stuck RCU. Even with extra RCU
>> debugging/info turned on, it doesn't give my any extra info.
>>
>> Config is attached. I can try and debug this on Monday, for now I've
>> pulled it out of for-next again.
> 
> Hmmm... it works fine with the same config here (qemu w/ 4 cpus
> configured).  Doesn't stuck RCU usually come from unbalanced RCU
> lock/unlocking?  That should trigger context or RCU warnings before
> anything else, weird.  Anyways, it would be great if you can provide
> more info on how to reproduce the problem.

The machine just sat there. I'll get some more info out of it and run a
bisect too.

-- 
Jens Axboe

