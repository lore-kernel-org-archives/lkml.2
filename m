Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0IQFeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:34:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59599
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab0IQFeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:34:22 -0400
Date: Thu, 16 Sep 2010 22:34:41 -0700 (PDT)
Message-Id: <20100916.223441.93463391.davem@davemloft.net>
To: drosenberg@vsecurity.com
Cc: grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kyle@mcmartin.ca, jeffm@suse.com,
        security@kernel.org
Subject: Re: [PATCH v4] drivers/net/tulip/de4x5.c: fix union member name in
 DE4X5_GET_REG ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284701436.2565.6.camel@dan>
References: <1284699944.2565.4.camel@dan>
	<20100916.222740.135972127.davem@davemloft.net>
	<1284701436.2565.6.camel@dan>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 17 Sep 2010 01:30:36 -0400

> Tiring doesn't begin to describe it.  Formatting undamaged.

:-)  Thanks.

> This was previously reported as a security issue due to leakage of
> uninitialized stack memory.  Jeff Mahoney pointed out that this is
> incorrect since the copied data is from a union (rather than a struct).
> Therefore, this patch is only under consideration for the sake of
> correctness, and is not security relevant. 
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> Acked-by: Grant Grundler <grundler@parisc-linux.org>

Applied.
