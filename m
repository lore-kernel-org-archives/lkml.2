Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916Ab2FVX4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:56:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38833 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2FVX4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:56:12 -0400
Date: Fri, 22 Jun 2012 16:56:11 -0700 (PDT)
Message-Id: <20120622.165611.2220193371527786713.davem@davemloft.net>
To: c_manoha@qca.qualcomm.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-06-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20453.302.671438.533390@gargle.gargle.HOWL>
References: <20120622201716.GB13918@tuxdriver.com>
	<20452.64701.760819.559191@gargle.gargle.HOWL>
	<20453.302.671438.533390@gargle.gargle.HOWL>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date: Sat, 23 Jun 2012 05:05:10 +0530

> Sujith Manoharan wrote:
>> John W. Linville wrote:
>> > Mohammed Shafi Shajakhan (1):
>> >       ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
>> 
>> Um, this commit doesn't really fix anything - the timeout is also
>> arbitrary. Can you remove this from the 3.5 queue ? Thanks.
> 
> A review of the patch later, I think it's good. At least there's a
> WARN_ON_ONCE() to indicate the situation in which the measurement fails.
> It might come in handy as a debugging aid.

Thanks for wasting our time.

Make these determinations when changes to into John's tree, not
later when he asks me to pull them into mine.
