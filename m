Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2LSXKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:10:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:59217 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab2LSXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:10:23 -0500
Message-ID: <1355958613.5397.54.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Thu, 20 Dec 2012 10:10:13 +1100
In-Reply-To: <CA+55aFw-cRskrvW07FVJd9HfrBhn41Ogi1Vv_v1U12zahzFu=A@mail.gmail.com>
References: <1355517897.19932.136.camel@pasglop>
	 <1355787094.5397.30.camel@pasglop>
	 <CA+55aFw-cRskrvW07FVJd9HfrBhn41Ogi1Vv_v1U12zahzFu=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 10:02 -0800, Linus Torvalds wrote:

> Anyway, I've pulled it in, but got a conflict on the kernel_thread
> cleanups from Al. And since the conflict was in the powerpc assembly
> code that I don't really know the details of, I did the
> straightforward resolve of it, but I'd like you to check it out.
> 
> (I haven't pushed it out yet, I'm waiting for the allmodconfig to
> finish compiling, so if you see this email quickly, but don't see the
> powerpc merge yet, just wait a few minutes)

Sorry for the delay, I verified that it looked right yesterday but
didn't manage to actually test it until today due to a problem with our
test farm. It's all good, thanks !

Cheers,
Ben.


