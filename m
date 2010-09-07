Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0IGBae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:30:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab0IGBa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:30:27 -0400
Date: Mon, 06 Sep 2010 18:30:44 -0700 (PDT)
Message-Id: <20100906.183044.27790719.davem@davemloft.net>
To: joe@perches.com
Cc: cooldavid@cooldavid.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/jme: Use pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283674865.23280.42.camel@Joe-Laptop>
References: <1283674865.23280.42.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 05 Sep 2010 01:21:05 -0700

> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Convert jeprintk to pr_err
> Remove jeprintk macro define
> Remove periods from end of logging messages
> Coalesce format strings
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
