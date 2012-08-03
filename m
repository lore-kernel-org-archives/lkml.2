Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2HCXxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 19:53:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41709 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2HCXxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 19:53:43 -0400
Date: Fri, 03 Aug 2012 16:53:42 -0700 (PDT)
Message-Id: <20120803.165342.1219524726899275535.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: netdev@vger.kernel.org, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        joe@perches.com, isdn@linux-pingi.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] isdnloop: fix and simplify isdnloop_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120803091001.GA15772@localhost>
References: <20120803073240.GA12723@localhost>
	<20120803.015126.198679260163049459.davem@davemloft.net>
	<20120803091001.GA15772@localhost>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>
Date: Fri, 3 Aug 2012 17:10:01 +0800

> Fix a buffer overflow bug by removing the revision and printk.
> 
> [   22.016214] isdnloop-ISDN-driver Rev 1.11.6.7 
> [   22.097508] isdnloop: (loop0) virtual card added
> [   22.174400] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff83244972
> [   22.174400] 
> [   22.436157] Pid: 1, comm: swapper Not tainted 3.5.0-bisect-00018-gfa8bbb1-dirty #129
> [   22.624071] Call Trace:
> [   22.720558]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
> [   22.815248]  [<ffffffff8222b623>] panic+0x110/0x329
> [   22.914330]  [<ffffffff83244972>] ? isdnloop_init+0xaf/0xb1
> [   23.014800]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
> [   23.090763]  [<ffffffff8108e24b>] __stack_chk_fail+0x2b/0x30
> [   23.185748]  [<ffffffff83244972>] isdnloop_init+0xaf/0xb1
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Applied.
