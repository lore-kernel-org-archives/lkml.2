Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2DVVfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:35:37 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:39840 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2DVVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:35:36 -0400
Date: Sun, 22 Apr 2012 23:35:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mark Salter <msalter@redhat.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] C6X: add support to build with BINFMT_ELF_FDPIC
Message-ID: <20120422213534.GA6570@merkur.ravnborg.org>
References: <1334958476-6296-1-git-send-email-msalter@redhat.com> <CAMjpGUe+CMkHP7owZym_6c2RDvgLzj8t+ZpLBuqQ0euk+ArV2Q@mail.gmail.com> <1335129679.12741.4.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335129679.12741.4.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > > --- a/fs/Kconfig.binfmt
> > > +++ b/fs/Kconfig.binfmt
> > >
> > >  config BINFMT_ELF_FDPIC
> > >        bool "Kernel support for FDPIC ELF binaries"
> > >        default y
> > > -       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU))
> > > +       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU) || TMS320C6X)
> > 
> > shouldn't the main arch symbol be "C6X" to match arch/c6x/ ?
> 
> It probably should have been. Most architectures use that convention but
> there are notable exceptions like powerpc and sh.
Please do not repeat past mistakes.
It should be trivial to fix.

Allow TMS320C6X for a sinel relase along with C6X - and drop it
when all users outside your arch has switched over.

	Sam
