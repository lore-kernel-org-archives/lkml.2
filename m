Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2H1Fxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 01:53:32 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:30911 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2H1Fxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 01:53:31 -0400
Message-ID: <503C5CD1.6040300@hp.com>
Date: Mon, 27 Aug 2012 23:53:21 -0600
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: T Makphaibulchoke <tmac@hp.com>, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, weiyang@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/resource.c: fix stack overflow in __reserve_region_with_split
References: <1346114874-6862-1-git-send-email-tmac@hp.com> <20120828043008.GJ20843@ram-ThinkPad-T61>
In-Reply-To: <20120828043008.GJ20843@ram-ThinkPad-T61>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 10:30 PM, Ram Pai wrote:
> For example:
> if the region requested is 1 to 100, but 20-30 is already reserved, than
> the earlier behavior would reserve 1-20 and 30-100. With your
> patch, it will just reserve 1-20.
> 
> RP
> 

Thanks RP for pointing the problem.  Sorry for missing part of the logic.  I'll fix the problem and resubmit.  Again, thank you very much for your comments.

Thanks,
Mak.

