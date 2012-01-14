Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2ANT4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 14:56:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab2ANT4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 14:56:13 -0500
Date: Sat, 14 Jan 2012 11:56:04 -0800 (PST)
Message-Id: <20120114.115604.2101782124431552110.davem@davemloft.net>
To: dvhart@linux.intel.com
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com,
        tomoya.rohm@gmail.com, jeffrey.t.kirsher@intel.com,
        paul.gortmaker@windriver.com, jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of
 failing probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F11A533.4040406@linux.intel.com>
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
	<20120114.001430.787918662083526597.davem@davemloft.net>
	<4F11A533.4040406@linux.intel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 14 Jan 2012 11:56:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>
Date: Sat, 14 Jan 2012 07:54:27 -0800

>> Please correct any hardware that hasn't shipped yet or is alpha/beta
>> hardware in testing, so that we don't need stuff like this.
> 
> I saw that the use of random_ether_addr is fairly prevalent, and
> attempted a roughly similar sort of approach to others I had seen. Do
> you consider all of those to be "necessary evils" or are there
> legitimate situations for its use?
> 
> In any case, with existing hardware out there that is unusable with the
> current pch_gbe driver, can we consider this workaround for inclusion?

I fear that people are just going to add this random MAC stuff way too
easily, it's a spreading disease.

Ship functional hardware instead.
