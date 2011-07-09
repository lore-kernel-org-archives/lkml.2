Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1GIJ4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 05:56:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1GIJz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 05:55:59 -0400
Date: Sat, 09 Jul 2011 02:55:40 -0700 (PDT)
Message-Id: <20110709.025540.2298552254249041622.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: mst@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] skbuff: clear tx zero-copy flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <1310195566.25391.6.camel@localhost.localdomain>
References: <1310195566.25391.6.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 09 Jul 2011 02:55:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Sat, 09 Jul 2011 00:12:46 -0700

> This patch clears tx zero-copy flag as needed.
> 
> Signed-off-by: Shirley Ma <xma@us.ibm.com>

Applied, thanks.
