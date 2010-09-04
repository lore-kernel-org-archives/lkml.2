Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0IDCqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:46:12 -0400
Received: from mail.atheros.com ([12.19.149.2]:41745 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab0IDCqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:46:09 -0400
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Greg KH <gregkh@suse.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 3 Sep 2010 19:46:07 -0700
Subject: RE: linux-next: Tree for September 3 (ar6k)
Thread-Topic: linux-next: Tree for September 3 (ar6k)
Thread-Index: ActL1xVPNpNTr1dkRniU+gjJ9ZNMwAABDCSA
Message-ID: <35B17FE5076C7040809188FBE7913F983F23479B6A@SC1EXMB-MBCL.global.atheros.com>
References: <20100903135206.d9bc2093.sfr@canb.auug.org.au>
 <20100903180614.81e5eee0.randy.dunlap@oracle.com>
 <35B17FE5076C7040809188FBE7913F983F23479B57@SC1EXMB-MBCL.global.atheros.com>
 <20100904021627.GA7695@suse.de>
In-Reply-To: <20100904021627.GA7695@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure. Will do that.

Regards,
Vipin

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, September 03, 2010 7:16 PM
> To: Vipin Mehta
> Cc: Randy Dunlap; Stephen Rothwell; linux-next@vger.kernel.org; LKML
> Subject: Re: linux-next: Tree for September 3 (ar6k)
> 
> On Fri, Sep 03, 2010 at 07:02:36PM -0700, Vipin Mehta wrote:
> > Apologies for the inconvenience. I synced to the linux-next tree and
> looked into the drivers/staging/ath6kl directory. I was able to compile
> the driver without any issues.
> >
> > One of the reasons this might happen is if the following symbolic link
> is broken.
> >
> > drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
> >
> > The link should point to
> drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw.0
> 
> I applied the patch and the symlink "should" be there, but in general,
> we shouldn't rely on a symlink in the kernel tree to work properly.
> 
> Can you send me a patch to fix this up so it works without a symlink?
> 
> thanks,
> 
> greg k-h
