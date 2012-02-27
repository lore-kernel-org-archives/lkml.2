Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2B0Fp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:45:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2B0Fp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:45:28 -0500
Date: Mon, 27 Feb 2012 00:44:52 -0500 (EST)
Message-Id: <20120227.004452.1938112966101853526.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: paul.gortmaker@windriver.com, tim.bird@am.sony.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: memory leak in udp_table_init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330321223.3330.1.camel@edumazet-laptop>
References: <1330147182.2462.25.camel@edumazet-laptop>
	<20120226.142038.556939530554716833.davem@davemloft.net>
	<1330321223.3330.1.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 26 Feb 2012 21:44:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 27 Feb 2012 06:40:23 +0100

> It was to match the comment we have few lines above :
> 
> /*
>  * The pid hash table is scaled according to the amount of memory in the
>  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
>  * more.
>  */

Granted, but that's not what the actual code did beforehand.

Please, make it a seperate change, thank you.

