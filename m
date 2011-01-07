Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1AGPFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:05:37 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42937 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab1AGPFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:05:36 -0500
Message-ID: <4D272C54.5010406@kernel.dk>
Date: Fri, 07 Jan 2011 16:08:04 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
References: <20110107110513.30776114.sfr@canb.auug.org.au>	<4D26C179.7030704@kernel.dk>	<AANLkTinyaZfsYv43046LWgu8U3kg6_79y+PTFO1RxtnY@mail.gmail.com>	<20110107231748.76170ff3.sfr@canb.auug.org.au>	<AANLkTimpVMLGBnP33Ro8MBtW3GJjskg0bBK717Xf-Mh_@mail.gmail.com> <20110108012211.1e19f0f7.sfr@canb.auug.org.au>
In-Reply-To: <20110108012211.1e19f0f7.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-07 15:22, Stephen Rothwell wrote:
> Hi,
> 
> On Fri, 7 Jan 2011 14:19:33 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> Hmm, I have pulled-in freshly from linux-2.6-block#for-next after you
>> published latest linux-next (next-20110107).
>> So, I guessed the (reported) issue is fixed, now.
> 
> No, the commit that caused the warnings was removed when I went back to
> using the block tree from next-20110106.  So it will come back unless
> fixed.

It is fixed in linux-2.6-block#for-next as-of earlier today, so if Sedat
pulled from there it should be gone.

-- 
Jens Axboe

