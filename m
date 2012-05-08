Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2EHSkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:40:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60494 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2EHSj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:39:57 -0400
Date: Tue, 08 May 2012 14:39:51 -0400 (EDT)
Message-Id: <20120508.143951.1433269599287007774.davem@davemloft.net>
To: erwanaliasr1@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tshimizu818@gmail.com
Subject: Re: [PATCH] pch_gbe: Adding read memory barriers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA96770.9070009@gmail.com>
References: <4FA822C4.60809@gmail.com>
	<4FA96770.9070009@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 May 2012 11:39:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erwan Velu <erwanaliasr1@gmail.com>
Date: Tue, 08 May 2012 20:35:28 +0200

> Le 07/05/2012 21:30, Erwan Velu a écrit :
>> From bb1e271db0fa1a29df19bede69faf8004389132d Mon Sep 17 00:00:00 2001
>> From: Erwan Velu <erwan.velu@zodiacaerospace.com>
>> Date: Mon, 7 May 2012 19:15:29 +0000
>> Subject: [PATCH 1/1] pch_gbe: Adding read memory barriers
> 
> Does my patch can be considered as acceptable or shall I rework
> something on it ?

You never need to ask questions like this.

Your patch is queued up to be reviewed in patchwork:

http://patchwork.ozlabs.org/project/netdev/list/

Therefore you only make more work for maintainers and irritate them by
asking this, and therefore it will take even longer for them to get to
your patch.
