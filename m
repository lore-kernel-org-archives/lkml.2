Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2CAADO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:03:14 -0500
Received: from tomato.cardboardbox.org.uk ([174.143.157.65]:44642 "EHLO
	tomato.cardboardbox.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757555Ab2CAADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:03:11 -0500
From: Daniel Palmer <me@danielpalmer.co.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: at91: SAM9G45 doesn't seem to register HDMAC controller anymore
Date: Thu, 1 Mar 2012 09:03:02 +0900
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <201202292121.58411.me@danielpalmer.co.uk> <4F4E541C.2040002@atmel.com>
In-Reply-To: <4F4E541C.2040002@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203010903.02096.me@danielpalmer.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 01, 2012 01:36:44 AM Nicolas Ferre wrote:

> Hi,

> So, you can find here:
> 1/ =>
> http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commitdiff;h=bd
> ad0b9a1c7222a771d25e2a20e81f5563968002
> http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commit;h=2756b
> f5c03bd6fec9462c0742dddb771838bf080
> 
> 2/ =>
> http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=43df92914e
> a0623893bcb801791d5d2be2f5e015
> 
> You can "cherry-pick" those patches using git.

I'll do that later on today when I get some free time and report the results. 
Thanks :)

Daniel

