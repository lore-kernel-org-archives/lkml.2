Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab2DBQ6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:58:53 -0400
Received: from tex.lwn.net ([70.33.254.29]:46271 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2DBQ6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:58:52 -0400
Date: Mon, 2 Apr 2012 10:58:50 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.32->3.0
Message-ID: <20120402105850.270fe7f2@lwn.net>
In-Reply-To: <4F75E46E.2000503@msgid.tls.msk.ru>
References: <4F75E46E.2000503@msgid.tls.msk.ru>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 20:50:54 +0400
Michael Tokarev <mjt@tls.msk.ru> wrote:

> I'm observing a dramatic slowdown of several hosts after upgrading
> from 2.6.32.y to 3.0.x i686 kernels (in both cases from kernel.org,
> on both cases the last version is relatively latest).
> 
> On 2.6.32 everything is fast.  On 3.0 the same operations which goes
> instantly takes ages to complete.
[...]
> What's the way to debug this issue?

There is a huge gap between those two kernels, so nobody is going to have
much luck guessing about what has changed.  A good first step might be to
do a binary search among the intermediate kernel releases to figure out
which one slowed things down for you.

jon
