Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1JSWrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:47:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51386 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1JSWrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:47:51 -0400
Date: Wed, 19 Oct 2011 18:46:45 -0400 (EDT)
Message-Id: <20111019.184645.1043687937652848590.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: fix wrong eee setting for rlt8111evl
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111019224312.GA10574@electric-eye.fr.zoreil.com>
References: <1318572877-1549-1-git-send-email-hayeswang@realtek.com>
	<20111019.165742.1621277627528277376.davem@davemloft.net>
	<20111019224312.GA10574@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 15:46:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Thu, 20 Oct 2011 00:43:12 +0200

> David Miller <davem@davemloft.net> :
>> > Correct the wrong parameter for setting EEE for RTL8111E-VL.
>> > 
>> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>> 
>> Francois, want me to apply this directly or will you handle it?
> 
> Please apply it directly. I must trust Hayes on this one.

Ok, will do, thanks!
