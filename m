Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1HWVDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:03:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab1HWVDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:03:45 -0400
Date: Tue, 23 Aug 2011 14:03:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] memblock: add memblock_start_of_DRAM()
Message-Id: <20110823140309.9a7b36dd.akpm@linux-foundation.org>
In-Reply-To: <20110806185923.GA8494@merkur.ravnborg.org>
References: <20110806185923.GA8494@merkur.ravnborg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Aug 2011 20:59:23 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> SPARC32 require access to the start address.
> Add a new helper memblock_start_of_DRAM() to give
> access to the address of the first memblock - which
> contains the lowest address.
> 

What is the status of the sparc32 patches which need this change?

If they're in some other tree then I'd suggest that this patch (which
needed some small changes for current mainline) join them in that tree.

Or we could slip this change into mainline immediately if that makes
life easier.

Or we could just wait for 3.1.
