Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2H2S7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:59:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52527 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2H2S7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:59:50 -0400
Date: Wed, 29 Aug 2012 14:59:47 -0400 (EDT)
Message-Id: <20120829.145947.282734125016260299.davem@davemloft.net>
To: marcin.slusarz@gmail.com
Cc: amwang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "netpoll: re-enable irq in poll_napi()" breaks boot with
 netconsole
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120829185329.GA2734@joi.lan>
References: <20120829185329.GA2734@joi.lan>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Wed, 29 Aug 2012 20:53:29 +0200

> Kernel 3.6-rc3 does not boot for me with netconsole enabled, while 3.6-rc2 did.
> I bisected it to commit 6bdb7fe31046ac50b47e83c35cd6c6b6160a475d "netpoll:
> re-enable irq in poll_napi()" and reverting it on top of current Linus' tree
> restores proper behaviour (disabling netconsole does this too).
> "Not booting" manifests as immediate hang after network card enabling.

Fix is already pending, thanks:

http://patchwork.ozlabs.org/patch/179954/
