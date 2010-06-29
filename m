Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0F2NT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:19:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54369 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0F2NTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:19:24 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH] Documentation: fix ubuntu distro name
Date: Tue, 29 Jun 2010 15:19:17 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: k@shinshilla.diku.dk, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, Julia Lawall <julia@diku.dk>,
       Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
References: <1277814677-1944-1-git-send-email-segooon@gmail.com> <201006291447.16073.npalix@diku.dk> <20100629125858.GA2279@shinshilla>
In-Reply-To: <20100629125858.GA2279@shinshilla>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291519.18326.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 29 June 2010 14:59:01 Kulikov Vasiliy wrote:
> On Tue, Jun 29, 2010 at 14:47 +0200, Nicolas Palix wrote:
> > Hi Kulikov,
> > 
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
> 

I figured out that point later, and sent a Acked-by for your original patch.
I think our mails have crossed each other.

Indeed, the version 0.1.9 does not provide the virtual rule feature, which is required
for the coccinelle files we have submitted.

-- 
Nicolas Palix
Web: http://www.diku.dk/~npalix/
