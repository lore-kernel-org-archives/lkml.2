Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2KRPPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:15:05 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51677 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2KRPPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:15:04 -0500
X-Nat-Received: from [202.181.97.72]:54368 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353251680.11303
To: dhowells@redhat.com
Cc: arnd@arndb.de, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
	<3677.1353246785@warthog.procyon.org.uk>
In-Reply-To: <3677.1353246785@warthog.procyon.org.uk>
Message-Id: <201211190014.BGD00598.LFOFtQFHOOMVJS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 19 Nov 2012 00:14:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 18112012 #8412787, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> 
> > I get build error which complains that include/uapi/asm-generic/auxvec.h is
> > missing although the file exists. I'm using gcc 3.3.5.
> > This bug seems to not happen with gcc 4.x.
> 
> What configuration?
> 
> David
> 

It is available at http://I-love.SAKURA.ne.jp/tmp/config-3.7-rc6 .
Workaround is to change to CONFIG_HEADERS_CHECK=n.

Regards.
