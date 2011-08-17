Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1HQWrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 18:47:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53581 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1HQWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 18:47:44 -0400
Date: Wed, 17 Aug 2011 15:47:37 -0700 (PDT)
Message-Id: <20110817.154737.1005956281645867066.davem@davemloft.net>
To: eilong@broadcom.com
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 0/3] bnx2x: Message logging cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313588528.7266.6.camel@lb-tlvb-eilong.il.broadcom.com>
References: <cover.1313360100.git.joe@perches.com>
	<1313588528.7266.6.camel@lb-tlvb-eilong.il.broadcom.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 17 Aug 2011 15:47:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eilon Greenstein" <eilong@broadcom.com>
Date: Wed, 17 Aug 2011 16:42:08 +0300

> On Sun, 2011-08-14 at 15:16 -0700, Joe Perches wrote: 
>> Joe Perches (3):
>>   bnx2x: Remove local defines for %pM and mac address
>>   bnx2x: Coalesce pr_cont uses and fix DP typos
>>   bnx2x: Use pr_fmt and message logging cleanups
>> 
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   67 ++++-----
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   48 ++++---
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |    4 +-
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c    |    5 +-
>>  .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |   23 ++--
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |  153 ++++++++++----------
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   72 ++++-----
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |   67 ++++-----
>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c  |   46 +++---
>>  9 files changed, 244 insertions(+), 241 deletions(-)
>> 
> 
> Thanks Joe, sorry it took a while - but ACK for all :)

All applied, thanks everyone.
