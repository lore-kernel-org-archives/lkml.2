Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0F2NBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:01:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab0F2NBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:01:16 -0400
Date: Tue, 29 Jun 2010 15:01:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Nicolas Palix <npalix@diku.dk>, k@suse.de,
       Randy Dunlap <rdunlap@xenotime.net>, Julia Lawall <julia@diku.dk>,
       Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: fix ubuntu distro name
In-Reply-To: <20100629125858.GA2279@shinshilla>
Message-ID: <alpine.LNX.2.00.1006291500360.13809@pobox.suse.cz>
References: <1277814677-1944-1-git-send-email-segooon@gmail.com> <201006291447.16073.npalix@diku.dk> <20100629125858.GA2279@shinshilla>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010, Kulikov Vasiliy wrote:

> > Indeed. I mixed things.
> > 
> > But Coccinelle was already in Karmic [1].
> > Can you submit a patch with 9.10 instead of 10.04 ?
> > 
> > I will Ack it.
> > 
> > Thanks.
> > 
> > [1] https://launchpad.net/ubuntu/+source/coccinelle
> 
> As you see in [1], coccinelle version in Karmic is 0.1.9.
> I don't know if it is buggy for linux.
> 
> In documentation it is 0.2.0:
> > Coccinelle (>=0.2.0) is available through the package manager
> > of many distributions, e.g. :
> > 
> >  - Debian (>=squeeze)
> >  - Fedora (>=13)
> >  - Ubuntu (>=10.04 Lucid Lynx)
> >  - OpenSUSE
> >  - Arch Linux
> >  - NetBSD
> >  - FreeBSD
> 
> So, if 0.1.9 is OK, I can make smth like this: 
> >  - Ubuntu (>=9.04 Karmic Koala, coccinelle = 0.1.9)

Do we really want all this in kernel documentation in the first place?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
