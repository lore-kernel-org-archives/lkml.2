Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab2H2EME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 00:12:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45782 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2H2EMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 00:12:01 -0400
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20120828203826.GA5868@p183.telecom.by>
References: <n> <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
	 <1345660110.5158.1969.camel@edumazet-glaptop>
	 <1345671778.5158.2369.camel@edumazet-glaptop>
	 <20120828203826.GA5868@p183.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Aug 2012 21:11:57 -0700
Message-ID: <1346213517.2522.2.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-28 at 23:38 +0300, Alexey Dobriyan wrote:

> Nothing can stop RCU!
> 
> After running "modprobe;rmmod" in a loop and "cat" in another loop for a while
> rmmod got stuck in D-state inside remove_proc_entry() with trace amounts of CPU time
> being consumed.
> 
> It didn't oopsed, though.

Thanks ! 

I'll polish this patch once LKS/LPC is over...

What particular module and/or proc file did you use for your tests ?



