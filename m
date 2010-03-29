Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0C2WcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:32:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53991
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240Ab0C2WcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:32:07 -0400
Date: Mon, 29 Mar 2010 15:32:08 -0700 (PDT)
Message-Id: <20100329.153208.190256896.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100329222132.GB12254@nowhere>
References: <20100329212839.GA12254@nowhere>
	<20100329.150253.11262563.davem@davemloft.net>
	<20100329222132.GB12254@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 30 Mar 2010 00:21:34 +0200

> $ ldd /usr/bin/as
> 	libopcodes-2.18.0.20080103.so => /usr/lib/libopcodes-2.18.0.20080103.so (0xf7ec4000)
> 	libbfd-2.18.0.20080103.so => /usr/lib/libbfd-2.18.0.20080103.so (0xf7e14000)
> 	libc.so.6 => /lib/libc.so.6 (0xf7ca0000)
> 	/lib/ld-linux.so.2 (0xf7efc000)

Ok, same here.

> The last kernel I know that don't have such problems is 2.6.31-rc6
> May be I should bisect?

Hmmm, since you know a good and bad point, yes a bisect
might be the best way to proceed here.

It might be quicker if you first test 2.6.32 and 2.6.33
and then use the results of that to guide your bisect.

Anyways, if you narrow it down to a commit I should be
able to fix this quickly.

Thanks!
