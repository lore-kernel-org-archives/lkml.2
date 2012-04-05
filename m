Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab2DEAdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:33:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51369 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEAdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:33:20 -0400
Date: Wed, 04 Apr 2012 20:33:13 -0400 (EDT)
Message-Id: <20120404.203313.756996430678321892.davem@davemloft.net>
To: joe@perches.com
Cc: jdmason@kudzu.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vxge: Convert macro to inline function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333579075.23520.19.camel@joe2Laptop>
References: <1333491271.2695.20.camel@joe2Laptop>
	<20120403.181830.799733266830291210.davem@davemloft.net>
	<1333579075.23520.19.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 17:33:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 04 Apr 2012 15:37:55 -0700

> On Tue, 2012-04-03 at 18:18 -0400, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Tue, 03 Apr 2012 15:14:31 -0700
>> > Convert the macro to inline function to check the arguments.
>> > Signed-off-by: Joe Perches <joe@perches.com>
>> > ---
>> >> Longer term I'd much rather see this turned into an inline
>> >> function with proper type checking etc.
>> > Something like this?
>> Yep.
> 
> I did sign the patch.
> I was intending that you could apply it.

Ok, I see now, applied.  Thanks Joe.
