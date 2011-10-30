Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1J3HN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 03:13:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1J3HNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 03:13:55 -0400
Date: Sun, 30 Oct 2011 03:13:45 -0400 (EDT)
Message-Id: <20111030.031345.1770003622707654735.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: mitsuo.hayasaka.hu@hitachi.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, shemminger@vyatta.com, andy@greyhouse.net,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH net-next] bonding: eliminate bond_close race conditions
From: David Miller <davem@davemloft.net>
In-Reply-To: <21320.1319852570@death>
References: <4EAA0ADF.5020504@hitachi.com>
	<20111027.231520.698587739433841485.davem@davemloft.net>
	<21320.1319852570@death>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 30 Oct 2011 00:13:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Fri, 28 Oct 2011 18:42:50 -0700

> 
> 	This patch resolves two sets of race conditions.
 ...
> Tested-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied, thanks a lot Jay.
