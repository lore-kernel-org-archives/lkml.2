Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1FMWaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:30:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1FMWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:30:13 -0400
Date: Mon, 13 Jun 2011 18:29:56 -0400 (EDT)
Message-Id: <20110613.182956.2297472017294393300.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: panweiping3@gmail.com, error27@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding:delete a dereference before check
From: David Miller <davem@davemloft.net>
In-Reply-To: <18226.1308003061@death>
References: <20110611081214.GA21427@shale.localdomain>
	<1307975410-13523-1-git-send-email-panweiping3@gmail.com>
	<18226.1308003061@death>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 13 Jun 2011 15:29:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Mon, 13 Jun 2011 15:11:01 -0700

> Weiping Pan <panweiping3@gmail.com> wrote:
> 
>>Dan Carpenter found that there was a dereference before a check,
>>added in 56d00c677de0(bonding:delete lacp_fast from ad_bond_info).
>>
>>Signed-off-by: Weiping Pan <panweiping3@gmail.com>
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied, thanks.
