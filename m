Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0HQLZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:25:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab0HQLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:25:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [MeeGo-dev] [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 2.6.35
Date: Tue, 17 Aug 2010 13:25:55 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>
References: <4C612AA4.5040100@dsn.okisemi.com> <001001cb3ddb$9929d9a0$66f8800a@maildom.okisemi.com> <20100817090637.GC3330@riccoc20.at.omicron.at>
In-Reply-To: <20100817090637.GC3330@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171325.55761.arnd@arndb.de>
X-Provags-ID: V02:K0:ewnWGgARLFUE67EMwQri9v8aG6EbfFblOnwu15VPpdN
 9sQ79T8peoQ620tuDVRQ+rXjUvan0ygF+NuO9FvArp1LGDrjpu
 KKh78szonpSl8MV4SNqkFD+1JFlWRBml6HAVnfooYU4LEJUuVN
 ubq42e3EBHjwz4PG4FVDN6CJBT3O+rkzj7dEPeUCaKhpx7b8m0
 iSwLynBEoUzlaEeQLiGUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010, Richard Cochran wrote:
> On Tue, Aug 17, 2010 at 04:12:45PM +0900, Masayuki Ohtake wrote:
> > Intel Topcliff IEEE1588 device driver API is developed according to Intel
> > Tolapai 1588 device driver.
> > Both APIs are the same.
> 
> But what is the "Intel Tolapai 1588 device driver?"
> 
> Is that a Linux driver?
> 
> If so, where can I find it?

I found it under
http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=17182

That driver was never submitted for inclusion anywhere, so it is not
really relevant here. The APIs are similar, but not identical, most
importantly they use a different ioctl command base number, but also
some of the structures are laid out slightly differently.

Ohtake-san, Richard's code already contains an abstraction for multiple
ieee1588 sources, which looks like it should perfectly fit your purposes.
I don't see room for another user interface, so please try to integrate
into version 5 of his ptp code.

	Arnd
