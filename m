Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1LOGrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:47:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37192 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1LOGrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:47:09 -0500
Date: Thu, 15 Dec 2011 01:43:59 -0500 (EST)
Message-Id: <20111215.014359.1153990753442293322.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: cantona@cantona.no-ip.org, hayeswang@realtek.com,
        linux-kernel@vger.kernel.org, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] r8169.c correct MSIEnable register offset
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111214213713.GA2907@electric-eye.fr.zoreil.com>
References: <CABJLtPHWfRLcbzDFR0ZXe4da3jv04eDZL2CabF1FTcaadoy0xQ@mail.gmail.com>
	<20111214213713.GA2907@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 14 Dec 2011 22:44:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 14 Dec 2011 22:37:13 +0100

> Su Kang Yin <cantona@cantona.no-ip.org> :
>> correct MSIEnable (bit 5) register to Config1 (offset 0x52) instead of
>> Config2 (offset 0x53)
> 
> I wonder where the inspiration for the MSIEnable bit came from.
> It looks like something was confused with the Message Control word
> in PCI space.
> 
> Imho you can simply remove it altogether.

Someone should find out what the real situation is with this.

Maybe it mirrors the PCI config space setting and is read-only, maybe
not.  But it should be determined for sure before changing this. :-)

