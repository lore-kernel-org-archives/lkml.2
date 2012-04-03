Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2DCWmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:42:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39143 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab2DCWmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:42:14 -0400
Date: Tue, 03 Apr 2012 18:40:04 -0400 (EDT)
Message-Id: <20120403.184004.2056266545823149252.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: cmetcalf@tilera.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tilepro ethernet driver: fix a few minor issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404083738.0b0f09ffc1f8c5a105c240eb@canb.auug.org.au>
References: <201203302325.q2UNPm8j012403@farm-0012.internal.tilera.com>
	<20120403.182335.782073108961783777.davem@davemloft.net>
	<20120404083738.0b0f09ffc1f8c5a105c240eb@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 15:40:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 4 Apr 2012 08:37:38 +1000

> Hi Dave,
> 
> On Tue, 03 Apr 2012 18:23:35 -0400 (EDT) David Miller <davem@davemloft.net> wrote:
>>
>> Format the comment:
>> 
>> 	/* Like
>> 	 * this.
>> 	 */
>> 
>> not:
>> 
>> 	/*
>> 	 * Like
>> 	 * this.
>> 	 */
> 
> People may be confused because Documentation/CodingStyle says to use the
> latter ...

I refuse to be dragged into this conversation, I'm completely aware
of the exact situation and I've stated my peace on this time and time
again.

