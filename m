Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1DUSDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:03:36 -0400
Received: from mail.digium.com ([216.207.245.2]:1026 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1DUSDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:03:35 -0400
Message-ID: <4DB0714B.90701@digium.com>
Date: Thu, 21 Apr 2011 13:02:51 -0500
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Neil Brown <neilb@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] block: don't propagate unlisted DISK_EVENTs to  userland
References: <20110421170826.GC15988@htj.dyndns.org> <BANLkTinwPt=aRSsh_Ppb8hLOaURh6mL2GQ@mail.gmail.com> <4DB06A06.7030208@fusionio.com>
In-Reply-To: <4DB06A06.7030208@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 12:31 PM, Jens Axboe wrote:
> On 2011-04-21 19:25, Linus Torvalds wrote:
>> Should I take these as patches, or through Jens/David/Who?
>>
>> I'll happily take them as patches, but I'd also like to hear
>> confirmation from the people who saw the lock-up that it's gone now..
> 
> I'm pulling them in now, with the elevator patch referenced in the IO
> scheduler switch email. I've verified that it fixes the ide-cd bug for
> me.

Jens, Tejun,

I was never seeing a lockup, just the stream of events, but I applied the
two patches on top of mainline (584f790467 from yesterday) and do not see
any issues on the system where I first noticed the constant events [1].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=33342

So,
Tested-by: Shaun Ruffell <sruffell@digium.com> 

Thanks,
Shaun
