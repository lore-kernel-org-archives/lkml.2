Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab0DQC2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 22:28:45 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:53826 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0DQC2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 22:28:44 -0400
Date: Sat, 17 Apr 2010 12:28:32 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: David Miller <davem@davemloft.net>
cc: Joe Perches <joe@perches.com>, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] mac8390: fix pr_info() calls and change return code
In-Reply-To: <20100416.132855.230883346.davem@davemloft.net>
Message-ID: <alpine.OSX.2.00.1004171107060.340@localhost>
References: <alpine.OSX.2.00.1004161214270.271@localhost>  <20100415.200113.215578006.davem@davemloft.net>  <alpine.OSX.2.00.1004161323340.271@localhost>  <alpine.OSX.2.00.1004161403160.271@localhost> <1271392454.2298.37.camel@Joe-Laptop.home>
 <alpine.OSX.2.00.1004162340370.271@localhost> <20100416.132855.230883346.davem@davemloft.net>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Apr 2010, David Miller wrote:

> 
> I just want to point out that with all the trouble you gave about Joe's 
> work, you're having one heck of a time even submitting your changes 
> properly. :-)

You are a thorough reviewer, despite the regrettable implication to the 
contrary in my first message in this thread. And you are quite right, I 
did not understand the pr_* macros at the time. I apologise.

I am hypersensitive to bit rot. I guess that's what happens when one makes 
it one's job to fix regressions in Linux.

Finn
