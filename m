Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab2EVTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:08:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49960 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2EVTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:08:34 -0400
Date: Tue, 22 May 2012 15:07:24 -0400 (EDT)
Message-Id: <20120522.150724.1070224867657733210.davem@davemloft.net>
To: tglx@linutronix.de
Cc: sam@ravnborg.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: use the common implementation of
 alloc_thread_info_node()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.02.1205221909540.3231@ionos>
References: <20120522151123.GA10058@merkur.ravnborg.org>
	<alpine.LFD.2.02.1205221909540.3231@ionos>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 12:07:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 22 May 2012 19:10:51 +0200 (CEST)

> On Tue, 22 May 2012, Sam Ravnborg wrote:
> 
>> >From 52d8a6d1b81a19e693a09df90275600f44293f43 Mon Sep 17 00:00:00 2001
>> From: Sam Ravnborg <sam@ravnborg.org>
>> Date: Tue, 22 May 2012 16:39:00 +0200
>> Subject: [PATCH] sparc32: use the common implementation of alloc_thread_info_node()
>> 
>> With sun4c removed we can fall-back to the common implementation.
>> 
>> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Applied, thanks everyone.
