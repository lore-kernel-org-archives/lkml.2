Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1FMW1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:27:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1FMW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:27:46 -0400
Date: Mon, 13 Jun 2011 18:25:29 -0400 (EDT)
Message-Id: <20110613.182529.1873616584449406901.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: linux@rainbow-software.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3c503: fix broken IRQ autoprobing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307915111.22348.652.camel@localhost>
References: <201106122140.51776.linux@rainbow-software.org>
	<1307915111.22348.652.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 13 Jun 2011 15:25:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 12 Jun 2011 17:45:11 -0400

> On Sun, 2011-06-12 at 21:40 +0200, Ondrej Zary wrote:
>> Fix broken IRQ autoprobing in 3c503 driver:
>>  - improper IRQ freeing (does not free IRQs causes WARN)
>>  - missing break when an working IRQ is found
>> 
>> The driver works with this patch.
> 
> I made a previous attempt to fix autoprobing (commit
> b0cf4dfb7cd21556efd9a6a67edcba0840b4d98d), but didn't have any hardware
> to test on.  In the process I introduced these new bugs.  Sorry about
> that.
> 
>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> [...]
> Reviewed-by: Ben Hutchings <ben@decadent.org.uk>

Applied, thanks.
