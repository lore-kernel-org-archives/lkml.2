Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1GJXJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:09:10 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:54814 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756814Ab1GJXJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:09:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gLBHxp0BJjaE0zsHcxOeZoT5RjVJSoYaPLcffuz1J7gop3XnvlPTeU/i0RzTZtl9iryxe9RIC8GphtASLl65pZlZvaXeJFae8tyyD+le7tCNCho7dfjZCS6k276w6aMr;
Date: Sun, 10 Jul 2011 16:09:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Should SUBLEVEL be removed for 3.x ?
Message-Id: <20110710160906.952bb38a.rdunlap@xenotime.net>
In-Reply-To: <alpine.LNX.2.00.1107110000280.2818@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107110000280.2818@swampdragon.chaosbits.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 00:07:13 +0200 (CEST) Jesper Juhl wrote:

> Hi
> 
> If the plan is that the new kernel is going to be 3.0 (3.x) and the 
> -stable kernels then get to tack on a third digit with EXTRAVERSION, then 
> it seems to me that the main Makefile should get rid of SUBLEVEL - or?
> 
> Or is the plan to ditch EXTRAVERSION for -stable kernels and have them use 
> SUBLEVEL instead?
> 
> There are a few scripts that need fixing if SUBLEVEL goes the way of the 
> Dodo, but I didn't want to start fixing those without a clear indication 
> of whether or not SUBLEVEL is going to/should die.
> 
> So what's going to happen to SUBLEVEL/EXTRAVERSION?

I cannot answer this, but I'd certainly like to see a clear answer
since I also have several scripts that need such attention.

---
~Randy
