Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2KYVP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 16:15:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2KYVP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 16:15:27 -0500
Date: Sun, 25 Nov 2012 16:15:19 -0500 (EST)
Message-Id: <20121125.161519.2093456773586153692.davem@davemloft.net>
To: joe@perches.com
Cc: steve.glendinning@shawell.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: Add logging message newlines
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353756469.6558.3.camel@joe-AO722>
References: <1353756469.6558.3.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 24 Nov 2012 03:27:49 -0800

> Avoid any possible message logging interleaving by adding
> missing newlines.
> 
> Align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
