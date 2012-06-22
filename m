Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898Ab2FVXzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:55:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38825 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2FVXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:55:34 -0400
Date: Fri, 22 Jun 2012 16:55:31 -0700 (PDT)
Message-Id: <20120622.165531.386085974835484549.davem@davemloft.net>
To: c_manoha@qca.qualcomm.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-06-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20452.64701.760819.559191@gargle.gargle.HOWL>
References: <20120622201716.GB13918@tuxdriver.com>
	<20452.64701.760819.559191@gargle.gargle.HOWL>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date: Sat, 23 Jun 2012 04:46:13 +0530

> John W. Linville wrote:
>> Mohammed Shafi Shajakhan (1):
>>       ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
> 
> Um, this commit doesn't really fix anything - the timeout is also
> arbitrary. Can you remove this from the 3.5 queue ? Thanks.

Not possible, already pushed out.
