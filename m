Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0ICKBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:01:45 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43146 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0ICKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:01:44 -0400
Date: Fri, 3 Sep 2010 12:01:40 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Bernhard Walle <walle@corscience.de>
Cc: Arnaud Patard <apatard@mandriva.com>, Christoph Hellwig <hch@lst.de>,
        linux-mips@linux-mips.org, ddaney@caviumnetworks.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: N32: Fix getdents64 syscall for n32
Message-ID: <20100903100140.GA29187@linux-mips.org>
References: <1283501734-6532-1-git-send-email-walle@corscience.de>
 <20100903084213.GA32339@lst.de>
 <m3pqwvb438.fsf@anduin.mandriva.com>
 <4C80BC3A.7010406@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C80BC3A.7010406@corscience.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 11:13:30AM +0200, Bernhard Walle wrote:

> >I guess the explanation is the one below :
> >
> >$ ./scripts/get_maintainer.pl -f arch/mips/kernel/scall64-n32.S
> >Ralf Baechle<ralf@linux-mips.org>
> >David Daney<ddaney@caviumnetworks.com>
> >Andrew Morton<akpm@linux-foundation.org>
> >"Eric W. Biederman"<ebiederm@xmission.com>
> >Christoph Hellwig<hch@lst.de>
> >linux-mips@linux-mips.org
> >linux-kernel@vger.kernel.org
> 
> Yes, I just used that script and trusted the results. Sorry for that.

I'm certainly not interested on getting cc'ed half of I2C patches or
Itanium framebuffer drivers.  The defaults are idiotic.  Anybody who
touched a file in the past year will get spammed.

Throw in a --nogit to disable the history search and you get:

Ralf Baechle <ralf@linux-mips.org>
linux-mips@linux-mips.org
linux-kernel@vger.kernel.org

cc'ing lkml is a bit pointless in many cases as well but the simplistic
filename pattern system in MAINTAINERS doesn't allow entries entries to
match only if no other previous entries are matching.

  Ralf
