Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0GZAFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 20:05:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48787
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787Ab0GZAFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 20:05:53 -0400
Date: Sun, 25 Jul 2010 17:06:11 -0700 (PDT)
Message-Id: <20100725.170611.71132252.davem@davemloft.net>
To: bhavesh@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.35-rc1] net-next: Fix an overflow bug in vmxnet3 Tx
 descriptor
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100725004329.GB6680@bhavesh-lx1.eng.vmware.com>
References: <20100725004329.GB6680@bhavesh-lx1.eng.vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bhavesh Davda <bhavesh@vmware.com>
Date: Sat, 24 Jul 2010 17:43:29 -0700

> ---

If you put the "---" there are the beginning of your message,
the whole commit message is discarded by GIT.

I said you should put "---" at the end of the commit message,
when you want to add more side commentary that should not appear
in the commit message but is for people in this thread to read.

I fixed this up when adding your patch, but I have no idea why
you did this.  Please don't do it again.

> Fix an overflow bug in vmxnet3 Tx descriptor
> 
> This patch fixes a bug where a 16K buffer on a Tx descriptor was overflowing
> into the 'gen' bit in the descriptor thereby corrupting the descriptor and
> stalling the transmit ring.
> 
> Signed-off-by: Bhavesh Davda <bhavesh@vmware.com>
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
> Signed-off-by: Matthew Delco <delcoM@vmware.com>
> Signed-off-by: Ronghua Zhang <ronghua@vmware.com>

Applied, thanks.
