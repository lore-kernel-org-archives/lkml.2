Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0GVBSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:18:30 -0400
Received: from norkia.v3.sk ([91.210.183.14]:33379 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0GVBS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:18:27 -0400
Subject: Re: [PATCH 3/3] [fs/sysv] V7: Add support for non-PDP11 v7
 filesystems
From: Lubomir Rintel <lkundrak@v3.sk>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1279622485.18203.22.camel@localhost.localdomain>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-2-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-3-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-4-git-send-email-lkundrak@v3.sk>
	 <20100719145851.GD25279@lst.de>
	 <1279622485.18203.22.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 03:17:58 +0200
Message-ID: <1279761478.4397.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 12:41 +0200, Lubomir Rintel wrote:
> On Mon, 2010-07-19 at 16:58 +0200, Christoph Hellwig wrote:
... 
> > Do you actually need the mount option?  We get away just fine with
> > it for sysv filesystems.  And if not I'd be consistent and accept the
> > options for both sysv and v7 filesystems.
...
> Coherent seems to always use PDP-11 bytesex. I can not check at the
> time, but I'm almost sure it never run on such machines (was PC and 68k
> only?), so I suspect the coherent kernel might have always done the
> translation to native byte order. I think I have some coherent (for PC)
> floppies at home, so I can check tomorrow.

This was just partly correct. Coherent indeed run on PDP-11 (and not on
68k), but the PC version uses the very same bytesex as PDP-11 one,
translating the byte order on the fly (_canl() routine defined in
i386/as.inc file of Coherent 4.2.10 for i386 kernel is used).

Thus the mount option is really only useful with v7 filesystem and none
of those handled with sysv filesystem.

-- 
Flash is the Web2.0 version of blink and animated gifs.
                                     -- Stephen Smoogen

