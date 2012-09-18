Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2IRUQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:16:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46709 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2IRUQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:16:31 -0400
Date: Tue, 18 Sep 2012 16:16:29 -0400 (EDT)
Message-Id: <20120918.161629.143875439883330517.davem@davemloft.net>
To: steffen.klassert@secunet.com
Cc: minipli@googlemail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfrm_user: return error pointer instead of NULL #2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120917071853.GD13023@secunet.com>
References: <1347652712-14584-1-git-send-email-minipli@googlemail.com>
	<20120917071853.GD13023@secunet.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Mon, 17 Sep 2012 09:18:53 +0200

> On Fri, Sep 14, 2012 at 09:58:32PM +0200, Mathias Krause wrote:
>> When dump_one_policy() returns an error, e.g. because of a too small
>> buffer to dump the whole xfrm policy, xfrm_policy_netlink() returns
>> NULL instead of an error pointer. But its caller expects an error
>> pointer and therefore continues to operate on a NULL skbuff.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied and queued up for -stable.

