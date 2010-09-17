Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0IQEza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 00:55:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55194
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab0IQEz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 00:55:29 -0400
Date: Thu, 16 Sep 2010 21:55:47 -0700 (PDT)
Message-Id: <20100916.215547.170109869.davem@davemloft.net>
To: drosenberg@vsecurity.com
Cc: divy@chelsio.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH v2] drivers/net/cxgb3/cxgb3_main.c: prevent reading
 uninitialized stack memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284586992.6275.93.camel@dan>
References: <1284586992.6275.93.camel@dan>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Wed, 15 Sep 2010 17:43:12 -0400

> Fixed formatting (tabs and line breaks).
> 
> The CHELSIO_GET_QSET_NUM device ioctl allows unprivileged users to read
> 4 bytes of uninitialized stack memory, because the "addr" member of the
> ch_reg struct declared on the stack in cxgb_extension_ioctl() is not
> altered or zeroed before being copied back to the user.  This patch
> takes care of it.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

Applied.
