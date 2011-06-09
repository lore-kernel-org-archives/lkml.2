Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1FIXGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:06:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34037 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab1FIXGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:06:15 -0400
Date: Thu, 09 Jun 2011 16:06:11 -0700 (PDT)
Message-Id: <20110609.160611.1243367560228886911.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: jj@chaosbits.net, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Sparc: Remove trigraph in die_if_kernel() message.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110609230322.GY11521@ZenIV.linux.org.uk>
References: <alpine.LNX.2.00.1106071627260.8844@swampdragon.chaosbits.net>
	<20110609.155943.162785602513776337.davem@davemloft.net>
	<20110609230322.GY11521@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Jun 2011 16:06:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 10 Jun 2011 00:03:22 +0100

> On Thu, Jun 09, 2011 at 03:59:43PM -0700, David Miller wrote:
>> > If I'm not mistaken, that "??!" will be taken as a trigraph for "|" by the 
>> > preprocessor, so the final string will end up either as
>> >   "Penguin instruction from Penguin mode|?!"
> 
> Not without -trigraphs, which is not on by default...

Oh, in that case I'll rever this.

Thanks Al.
