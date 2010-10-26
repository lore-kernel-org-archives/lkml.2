Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0JZQbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:31:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51495
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab0JZQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:31:50 -0400
Date: Tue, 26 Oct 2010 09:32:13 -0700 (PDT)
Message-Id: <20101026.093213.115933777.davem@davemloft.net>
To: namhyung@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: make CONFIG_SPARC_LEON depends on !SMP to fix
 build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101026.090428.189722351.davem@davemloft.net>
References: <20101026.085338.104057457.davem@davemloft.net>
	<1288108960.1717.1.camel@leonhard>
	<20101026.090428.189722351.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 26 Oct 2010 09:04:28 -0700 (PDT)

> From: Namhyung Kim <namhyung@gmail.com>
> Date: Wed, 27 Oct 2010 01:02:40 +0900
> 
>> 2010-10-26 (ȭ), 08:53 -0700, David Miller:
>>> Great, I'll apply all three of your patches thanks.
>> 
>> Thanks. BTW, can you please take a look below too?
>> 
>> http://lkml.org/lkml/2010/10/25/13
> 
> Sure.

I've applied this.

Please CC: sparclinux@vger.kernel.org on such patches next time, so
that it gets into my patchwork queue and you don't need to ask me
to go looking around in other places for your patches.

Thanks.
