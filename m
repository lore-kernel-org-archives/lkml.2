Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab0E0EKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:10:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45965
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab0E0EJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:09:58 -0400
Date: Wed, 26 May 2010 21:10:08 -0700 (PDT)
Message-Id: <20100526.211008.116373263.davem@davemloft.net>
To: julia@diku.dk
Cc: ursula.braun@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/17] net/iucv: Add missing spin_unlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005261756330.23743@ask.diku.dk>
References: <Pine.LNX.4.64.1005261756330.23743@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Wed, 26 May 2010 17:56:48 +0200 (CEST)

> Add a spin_unlock missing on the error path.  There seems like no reason
> why the lock should continue to be held if the kzalloc fail.

Applied, thanks.
