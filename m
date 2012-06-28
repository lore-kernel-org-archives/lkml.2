Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2F1UOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:14:24 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25548 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2F1UOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:14:23 -0400
Message-ID: <1340914459.3821.0.camel@lorien2>
Subject: Re: linux-next: Tree for Jun 27 (eliminated_printk)
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: shuahkhan@gmail.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Date: Thu, 28 Jun 2012 14:14:19 -0600
In-Reply-To: <20120628085226.af0623e39a282192935047c3@canb.auug.org.au>
References: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
	 <4FEB340D.3040908@xenotime.net> <1340814569.16533.53.camel@joe2Laptop>
	 <20120628085226.af0623e39a282192935047c3@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 08:52 +1000, Stephen Rothwell wrote:
> Hi Matthew,
> 
> One for you ...
> 
> On Wed, 27 Jun 2012 09:29:29 -0700 Joe Perches <joe@perches.com> wrote:
> >
> > On Wed, 2012-06-27 at 09:25 -0700, Randy Dunlap wrote:
> > > 
> > > on i386:
> > > 
> > > drivers/platform/x86/thinkpad_acpi.c: In function 'drv_acpi_handle_init':
> > > drivers/platform/x86/thinkpad_acpi.c:684:2: error: implicit declaration of function 'eliminated_printk'
> > > 
> > > drivers/platform/x86/fujitsu-laptop.c: In function 'call_fext_func':
> > > drivers/platform/x86/fujitsu-laptop.c:223:3: error: implicit declaration of function 'eliminated_printk'
> > > 
> > > 
> > > Full randconfig file is attached.
> > 
> > Thanks Randy.
> > 
> > This patch depends on the first patch in the series
> > which hasn't been applied.
> > 
> > https://lkml.org/lkml/2012/6/17/229
> > https://lkml.org/lkml/2012/6/17/231

Has this bean fixed in June 28th tree??

-- Shuah
> 
> 


