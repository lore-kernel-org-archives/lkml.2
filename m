Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0DUXez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:34:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55472
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755360Ab0DUXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:34:53 -0400
Date: Wed, 21 Apr 2010 16:34:58 -0700 (PDT)
Message-Id: <20100421.163458.239333058.davem@davemloft.net>
To: divy@chelsio.com
Cc: h-shimamoto@ct.jp.nec.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb3: fix linkup issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BCF4E0E.1080805@chelsio.com>
References: <4BCD0424.8030501@ct.jp.nec.com>
	<4BCF4E0E.1080805@chelsio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 21 Apr 2010 12:12:14 -0700

> Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> I encountered an issue that not to link up on cxgb3 fabric.
>> I bisected and found that this regression was introduced by
>> 0f07c4ee8c800923ae7918c231532a9256233eed.
>>
>> Correct to pass phy_addr to cphy_init() at t3_xaui_direct_phy_prep().
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>   
> 
> Sorry for the review delay, I just came back from some time off.
> Acked-by: Divy Le Ray <divy@chelsio.com>

Applied to net-2.6, thanks.
