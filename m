Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab0HLRbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:31:16 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:39083 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0HLRbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:31:14 -0400
Subject: Re: linux-next: Tree for August 9 (nfs)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-nfs@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100812091842.6a3b84b9.randy.dunlap@oracle.com>
References: <20100809132314.789e13f3.sfr@canb.auug.org.au>
	 <20100809100856.b03a9bc1.randy.dunlap@oracle.com>
	 <20100812091842.6a3b84b9.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 13:31:08 -0400
Message-ID: <1281634268.14329.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 2 sum rcpts/h 9 sum msgs/h 2 total rcpts 837 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 23F2AF36AEFF259D455E4152B0188C54146C49BB
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 321 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 09:18 -0700, Randy Dunlap wrote:
> On Mon, 9 Aug 2010 10:08:56 -0700 Randy Dunlap wrote:
> 
> ping??

Hi Randy,

I'm sorry. A heavy travel schedule is affecting my response time at the
moment. I'll try to take care of this by Tuesday (when I get back home)
if not before.

Cheers
  Trond

> > On Mon, 9 Aug 2010 13:23:14 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > As the merge window is open, please do not add 2.6.37 material to your
> > > linux-next included trees until after 2.6.36-rc1.
> > > 
> > > Changes since 20100807:
> > 
> > 
> > ERROR: "svc_gss_principal" [fs/nfs/nfs.ko] undefined!
> > 
> > 
> > because in fs/nfs/Kconfig, NFS_V4 selects RPCSEC_GSS_KRB5
> > and/or in fs/nfsd/Kconfig, NFSD_V4 selects RPCSEC_GSS_KRB5.
> > 
> > RPCSEC_GSS_KRB5 does 5 selects, but none of these is enforced/followed
> > by the fs/nfs[d]/Kconfig configs:
> > 
> > 	select SUNRPC_GSS
> > 	select CRYPTO
> > 	select CRYPTO_MD5
> > 	select CRYPTO_DES
> > 	select CRYPTO_CBC
> > 
> > 
> > Failing config is attached.
> > ---
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



