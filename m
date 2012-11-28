Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2K1Nzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:55:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240Ab2K1Nzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:55:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201211251802.BEJ43247.SHFOJOFVQLFtOM@I-love.SAKURA.ne.jp>
References: <201211251802.BEJ43247.SHFOJOFVQLFtOM@I-love.SAKURA.ne.jp> <201211192202.IBE48444.VHFLtOSOQFOMJF@I-love.SAKURA.ne.jp> <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp> <24020.1353323415@warthog.procyon.org.uk> <26846.1353334165@warthog.procyon.org.uk> <201211202322.AED21884.FJtLHOFSOOQVMF@I-love.SAKURA.ne.jp>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, sam@ravnborg.org
Cc: dhowells@redhat.com, arnd@arndb.de, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
Date: Wed, 28 Nov 2012 13:55:14 +0000
Message-ID: <26876.1354110914@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Tetsuo Handa wrote:
> > Linux 3.6 builds fine. I can't use "git bisect" until Linux 3.7-rc6 but
> > possibly caused by either commit 10b63956 "UAPI: Plumb the UAPI Kbuilds
> > into the user header installation and checking" or commit 40f1d4c2 "UAPI:
> > Remove the objhdr-y export list".
> 
> Bisected to commit 10b63956 "UAPI: Plumb the UAPI Kbuilds into the user header
> installation and checking".

Indeed, but that doesn't help much.  The problem is that make's behaviour has
apparently changed.  I could do with Sam Ravnborg's help to work around this
since I think he's mainly responsible for the Makefile infrastructure.

David
