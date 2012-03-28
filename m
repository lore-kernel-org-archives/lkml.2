Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab2C1Bdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 21:33:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47527 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab2C1Bdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 21:33:49 -0400
Date: Tue, 27 Mar 2012 21:32:44 -0400 (EDT)
Message-Id: <20120327.213244.340230223876758625.davem@davemloft.net>
To: andi@firstfloor.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH 10/13] smsc911x: Use lockdep_assert_held instead of
 home grown buggy construct
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332895637-32572-11-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
	<1332895637-32572-11-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Mar 2012 18:32:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 27 Mar 2012 17:47:14 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
