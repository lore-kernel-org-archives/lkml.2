Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2JWVxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:53:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42670 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2JWVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:53:39 -0400
Subject: Re: [PATCH v5] posix timers: allocate timer id per process
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, peterz@infradead.org,
        mingo@redhat.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        xemul@parallels.com
In-Reply-To: <alpine.LFD.2.02.1210232345200.2756@ionos>
References: <20121023073913.23514.87934.stgit@localhost.localdomain>
	 <1350978723.8609.1555.camel@edumazet-glaptop>
	 <alpine.LFD.2.02.1210232345200.2756@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Oct 2012 23:53:36 +0200
Message-ID: <1351029216.6537.3.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 23:47 +0200, Thomas Gleixner wrote:

> Not so good to me.
>  
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> And that should be either an Acked-by or a Reviewed-by. You can't sign
> off on patches which have not been submitted or transported by you.

I actually gave some input, provided a hash function, and so on.

So this SOB was valid. I do that all the time.

And yes, there are bugs in this patch, as many patches that were merged
in linux tree, included by you.

Thanks


