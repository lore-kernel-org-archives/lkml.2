Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab1BAU3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:29:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39913
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab1BAU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:29:37 -0500
Date: Tue, 01 Feb 2011 12:30:12 -0800 (PST)
Message-Id: <20110201.123012.193709953.davem@davemloft.net>
To: Ramkrishna.Vepa@exar.com
Cc: weil@mail.berlios.de, Sivakumar.Subramani@exar.com,
        Sreenivasa.Honnur@exar.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jon.Mason@exar.com
Subject: Re: [PATCH] vxge: Fix wrong boolean operator {nodisc}
From: David Miller <davem@davemloft.net>
In-Reply-To: <FCA91A92EE52B041906A0358FC28FCC38EFBE64996@FRE1EXCH02.hq.exar.com>
References: <1296253817-7668-1-git-send-email-weil@mail.berlios.de>
	<FCA91A92EE52B041906A0358FC28FCC38EFBE64996@FRE1EXCH02.hq.exar.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkrishna Vepa <Ramkrishna.Vepa@exar.com>
Date: Mon, 31 Jan 2011 23:26:40 -0800

>> This error is reported by cppcheck:
>> drivers/net/vxge/vxge-config.c:3693: warning: Mutual exclusion over ||
>> always evaluates to true. Did you intend to use && instead?
>> 
>> It looks like cppcheck is correct, so fix this. No test was run.
>> 
>> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
...
> Fix looks good. Thanks!
> 
> Acked-by: Ram Vepa <ram.vepa@exar.com>

Thanks for reviewing, applied.
