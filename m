Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966340Ab2ERRzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:55:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43191 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082Ab2ERRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:55:47 -0400
Date: Fri, 18 May 2012 13:53:35 -0400 (EDT)
Message-Id: <20120518.135335.1910007668963165501.davem@davemloft.net>
To: sam@ravnborg.org
Cc: anna-maria@glx-um.de, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch 20/24] sparc: Use: generic time config
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120518175041.GA17334@merkur.ravnborg.org>
References: <20120518163020.548627576@glx-um.de>
	<20120518163106.987564297@glx-um.de>
	<20120518175041.GA17334@merkur.ravnborg.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 18 May 2012 10:53:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 18 May 2012 19:50:41 +0200

> On Fri, May 18, 2012 at 04:45:54PM -0000, Anna-Maria Gleixner wrote:
>> Index: linux/arch/sparc/Kconfig
>> ===================================================================
>> --- linux.orig/arch/sparc/Kconfig
>> +++ linux/arch/sparc/Kconfig
>> @@ -30,11 +30,13 @@ config SPARC
>>  	select USE_GENERIC_SMP_HELPERS if SMP
>>  	select GENERIC_PCI_IOMAP
>>  	select HAVE_NMI_WATCHDOG if SPARC64
>> +	select GENERIC_CMOS_UPDATE
> 
> I do not see where we define the GENERIC_CMOS_UPDATE symbol,
> so this looks wrong.
> 
> I looked only in upstream - and I did not look
> in -tip.

On top of that, I get the impression that this patch series is not
bisectable at all.
