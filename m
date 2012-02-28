Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687Ab2B1VHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:07:50 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49386 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965394Ab2B1VHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:07:46 -0500
Date: Tue, 28 Feb 2012 16:07:32 -0500 (EST)
Message-Id: <20120228.160732.236576548660822884.davem@davemloft.net>
To: joe@perches.com
Cc: JBottomley@parallels.com, trivial@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial next 7/9] scsi: Use vsprintf extention %pf with
 builtin_return_address
From: David Miller <davem@davemloft.net>
In-Reply-To: <aa5a8942edf8a59745a514a099e78eaaae03fe26.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
	<aa5a8942edf8a59745a514a099e78eaaae03fe26.1330454853.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 13:07:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 28 Feb 2012 10:49:36 -0800

> Emit the function name not the address when possible.
> 
> builtin_return_address() gives an address.  When building
> a kernel with CONFIG_KALLSYMS, emit the actual function
> name not the address.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: David S. Miller <davem@davemloft.net>
