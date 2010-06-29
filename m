Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0F2Ngd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:36:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39486 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab0F2Ngc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:36:32 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Documentation: fix ubuntu distro name
Date: Tue, 29 Jun 2010 15:36:25 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Kulikov Vasiliy <segooon@gmail.com>, k@suse.de,
       Randy Dunlap <rdunlap@xenotime.net>, Julia Lawall <julia@diku.dk>,
       Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
References: <1277814677-1944-1-git-send-email-segooon@gmail.com> <20100629125858.GA2279@shinshilla> <alpine.LNX.2.00.1006291500360.13809@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1006291500360.13809@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291536.25807.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 June 2010 15:01:14 Jiri Kosina wrote:
> On Tue, 29 Jun 2010, Kulikov Vasiliy wrote:
> 
> > > Indeed. I mixed things.
> > > 
> > > But Coccinelle was already in Karmic [1].
> > > Can you submit a patch with 9.10 instead of 10.04 ?
> > > 
> > > I will Ack it.
> > > 
> > > Thanks.
> > > 
> > > [1] https://launchpad.net/ubuntu/+source/coccinelle
> > 
> > As you see in [1], coccinelle version in Karmic is 0.1.9.
> > I don't know if it is buggy for linux.
> > 
> > In documentation it is 0.2.0:
> > > Coccinelle (>=0.2.0) is available through the package manager
> > > of many distributions, e.g. :
> > > 
> > >  - Debian (>=squeeze)
> > >  - Fedora (>=13)
> > >  - Ubuntu (>=10.04 Lucid Lynx)
> > >  - OpenSUSE
> > >  - Arch Linux
> > >  - NetBSD
> > >  - FreeBSD
> > 
> > So, if 0.1.9 is OK, I can make smth like this: 
> > >  - Ubuntu (>=9.04 Karmic Koala, coccinelle = 0.1.9)
> 
> Do we really want all this in kernel documentation in the first place?
> 

It addresses a comment [1] I got during the review process.

[1] http://lkml.org/lkml/2010/5/10/316

> 

-- 
Nicolas Palix
Tel: (+33) 1 44 27 87 25
Tel: (+33) 6 81 07 91 72
Web: http://www.diku.dk/~npalix/
