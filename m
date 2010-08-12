Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab0HLQTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:19:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25246 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0HLQTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:19:35 -0400
Date: Thu, 12 Aug 2010 09:18:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-nfs@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 9 (nfs)
Message-Id: <20100812091842.6a3b84b9.randy.dunlap@oracle.com>
In-Reply-To: <20100809100856.b03a9bc1.randy.dunlap@oracle.com>
References: <20100809132314.789e13f3.sfr@canb.auug.org.au>
	<20100809100856.b03a9bc1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010 10:08:56 -0700 Randy Dunlap wrote:

ping??

> On Mon, 9 Aug 2010 13:23:14 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > As the merge window is open, please do not add 2.6.37 material to your
> > linux-next included trees until after 2.6.36-rc1.
> > 
> > Changes since 20100807:
> 
> 
> ERROR: "svc_gss_principal" [fs/nfs/nfs.ko] undefined!
> 
> 
> because in fs/nfs/Kconfig, NFS_V4 selects RPCSEC_GSS_KRB5
> and/or in fs/nfsd/Kconfig, NFSD_V4 selects RPCSEC_GSS_KRB5.
> 
> RPCSEC_GSS_KRB5 does 5 selects, but none of these is enforced/followed
> by the fs/nfs[d]/Kconfig configs:
> 
> 	select SUNRPC_GSS
> 	select CRYPTO
> 	select CRYPTO_MD5
> 	select CRYPTO_DES
> 	select CRYPTO_CBC
> 
> 
> Failing config is attached.
> ---


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
