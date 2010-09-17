Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0IQEzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 00:55:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55184
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab0IQEzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 00:55:16 -0400
Date: Thu, 16 Sep 2010 21:55:35 -0700 (PDT)
Message-Id: <20100916.215535.128594045.davem@davemloft.net>
To: drosenberg@vsecurity.com
Cc: j.dumon@option.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Subject: Re: [PATCH v2] drivers/net/usb/hso.c: prevent reading
 uninitialized memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284587008.6275.95.camel@dan>
References: <1284587008.6275.95.camel@dan>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Wed, 15 Sep 2010 17:43:28 -0400

> Fixed formatting (tabs and line breaks).
> 
> The TIOCGICOUNT device ioctl allows unprivileged users to read
> uninitialized stack memory, because the "reserved" member of the
> serial_icounter_struct struct declared on the stack in hso_get_count()
> is not altered or zeroed before being copied back to the user.  This
> patch takes care of it.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

Applied.
