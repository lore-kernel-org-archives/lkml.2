Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2FWKpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:45:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47797 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2FWKpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120622.165611.2220193371527786713.davem@davemloft.net>
References: <20120622201716.GB13918@tuxdriver.com>
	<20452.64701.760819.559191@gargle.gargle.HOWL>
	<20453.302.671438.533390@gargle.gargle.HOWL>
	<20120622.165611.2220193371527786713.davem@davemloft.net>
Date: Sat, 23 Jun 2012 16:15:51 +0530
Message-ID: <CAD2nsn1wRUv3+585X0iaTdq4gfaHLk99GifmSktUSHEyrM4Erw@mail.gmail.com>
Subject: Re: pull request: wireless 2012-06-22
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: c_manoha@qca.qualcomm.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 5:26 AM, David Miller <davem@davemloft.net> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Date: Sat, 23 Jun 2012 05:05:10 +0530
>
>> Sujith Manoharan wrote:
>>> John W. Linville wrote:
>>> > Mohammed Shafi Shajakhan (1):
>>> >       ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
>>>
>>> Um, this commit doesn't really fix anything - the timeout is also
>>> arbitrary. Can you remove this from the 3.5 queue ? Thanks.
>>
>> A review of the patch later, I think it's good. At least there's a
>> WARN_ON_ONCE() to indicate the situation in which the measurement fails.
>> It might come in handy as a debugging aid.
>
> Thanks for wasting our time.
>
> Make these determinations when changes to into John's tree, not
> later when he asks me to pull them into mine.

apologies for the confusion, i haven't got a better timeout from very
few of the folks
queried, I should have updated that. As the patch is being already
pushed in, if we get
a proper timeout, we would fix it later with a proper timeout.


-- 
thanks,
shafi
