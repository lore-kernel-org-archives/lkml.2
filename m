Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab1FUSpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:45:53 -0400
Received: from mail.perches.com ([173.55.12.10]:3109 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab1FUSpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:45:35 -0400
Subject: Re: [PATCH net-next V2] drivers/net: Remove casts of void *
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110617.151903.1203335395245647912.davem@davemloft.net>
References: <3bea9d0803a4ebfee2bb0f6e42defbf76126dc86.1308287030.git.joe@perches.com>
	 <20110617.151903.1203335395245647912.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 11:45:34 -0700
Message-ID: <1308681934.3338.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 15:19 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Thu, 16 Jun 2011 22:08:06 -0700
> > Unnecessary casts of void * clutter the code.
> > These are the remainder casts after several specific
> > patches to remove netdev_priv and dev_priv.
> > Done via coccinelle script (and a little editing):
> Applied, thanks.

Unapplied?  I don't see this in net-next.

