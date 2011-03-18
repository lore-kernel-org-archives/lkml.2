Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1CRT4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:56:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46787
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667Ab1CRT4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:56:47 -0400
Date: Fri, 18 Mar 2011 12:57:24 -0700 (PDT)
Message-Id: <20110318.125724.258093097.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: ahiliation@yahoo.co.in, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: patch for format issues and header bug in net/ipv4/icmp.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300477261.2589.28.camel@bwh-desktop>
References: <20110318183529.GA3617@debian.Jeff>
	<1300477261.2589.28.camel@bwh-desktop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 18 Mar 2011 19:41:01 +0000

> On Sat, 2011-03-19 at 00:05 +0530, Jeffrin Jose wrote:
>> hello ,
>> 
>> I have created a patch for net/ipv4/icmp.c
>> using checkpatch.pl script to fix several warnings
>> and an error.
> 
> You need to learn C programming before trying to correct C programs.
> You should not just do what it takes to make checkpatch.pl happy.

I completely agree, and I absolutely refuse to apply this patch.
