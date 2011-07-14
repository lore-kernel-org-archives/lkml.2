Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1GNUnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:43:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39358 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab1GNUnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:43:53 -0400
Message-ID: <4E1F54FA.1060506@zytor.com>
Date: Thu, 14 Jul 2011 13:43:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, tglx@linutronix.de, benh@kernel.crashing.org,
        yinghai@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
References: <1310462166-31469-1-git-send-email-tj@kernel.org>	<1310462166-31469-14-git-send-email-tj@kernel.org>	<4E1F4D2C.3000507@zytor.com>	<CAOS58YPhFWEYgB7moPoTj+BKBn6WMHCi5FqZ5eYp+m4bbEN_7A@mail.gmail.com>	<4E1F5040.50004@zytor.com>	<CAOS58YM38mwmLcErARLc2+7wBrBa5Je3VOM5L28z63L6+ysqpQ@mail.gmail.com>	<4E1F53D9.2000606@zytor.com> <CAOS58YPkDG2v3ULRMK15mwvpAKyPpjYL34N+BMZwWZB3DNOEnw@mail.gmail.com>
In-Reply-To: <CAOS58YPkDG2v3ULRMK15mwvpAKyPpjYL34N+BMZwWZB3DNOEnw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 01:41 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jul 14, 2011 at 10:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Hmm... I was only looking at the early boot messages which didn't
>>> include the io ranges.  It ultimately is a cosmetic issue so my
>>> opinions aren't very strong but I think we can leave [mm]io ranges
>>> alone and converge the rest into [ ) ranges sans the brackets?
>>
>> Agreed it's a cosmetic issue... this discussion has already been had,
>> though, and the consensus is to move the kernel to the standardized
>> resource format.
> 
> OIC, in that case, please go ahead and change it.  It seems that we
> haven't been too successful at applying the decision tho. :(
> 

It's a work in progress.

	-hpa
