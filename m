Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab2C1Be4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 21:34:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47541 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2C1Bez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 21:34:55 -0400
Date: Tue, 27 Mar 2012 21:32:37 -0400 (EDT)
Message-Id: <20120327.213237.1580978953589022069.davem@davemloft.net>
To: andi@firstfloor.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, netdev@vger.kernel.org, samuel@sortiz.org
Subject: Re: [PATCH 08/13] irda: remove spin_is_locked
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332895637-32572-9-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
	<1332895637-32572-9-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Mar 2012 18:32:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 27 Mar 2012 17:47:12 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> It's hard to imagine how this spin_is_locked debugging check is not
> totally racy.  Remove it.
> 
> Cc: netdev@vger.kernel.org
> Cc: samuel@sortiz.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
