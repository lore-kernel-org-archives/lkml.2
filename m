Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2KRNxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:53:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab2KRNxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:53:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
References: <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: dhowells@redhat.com, arnd@arndb.de, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
Date: Sun, 18 Nov 2012 13:53:05 +0000
Message-ID: <3677.1353246785@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> I get build error which complains that include/uapi/asm-generic/auxvec.h is
> missing although the file exists. I'm using gcc 3.3.5.
> This bug seems to not happen with gcc 4.x.

What configuration?

David
