Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031525Ab2K3Sn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:43:57 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47065 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031507Ab2K3Snx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:43:53 -0500
From: Paul Moore <paul@paul-moore.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: Add missing depends on INET in Kconfig
Date: Fri, 30 Nov 2012 13:43:49 -0500
Message-ID: <8363749.LmN8tGshhp@sifl>
User-Agent: KMail/4.9.3 (Linux/3.6.6-gentoo; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50B8EF79.4080907@xenotime.net>
References: <20121129174057.99da02b15426c76054d05592@canb.auug.org.au> <50B8ECB3.2090801@schaufler-ca.com> <50B8EF79.4080907@xenotime.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 30, 2012 09:40:09 AM Randy Dunlap wrote:
> On 11/30/2012 09:28 AM, Casey Schaufler wrote:
> > Because NETLABEL depends on INET SECURITY_SMACK
> > has to explicitly call out the dependency.
> > 
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks for the quick fix.

+1

Thanks Casey.

> > ---
> > 
> >  security/smack/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/security/smack/Kconfig b/security/smack/Kconfig
> > index 9fb14ef..1be1088 100644
> > --- a/security/smack/Kconfig
> > +++ b/security/smack/Kconfig
> > @@ -1,5 +1,6 @@
> > 
> >  config SECURITY_SMACK
> >  
> >  	bool "Simplified Mandatory Access Control Kernel Support"
> > 
> > +	depends on INET
> > 
> >  	depends on NET
> >  	depends on SECURITY
> >  	select NETLABEL
> > 
> > --
-- 
paul moore
www.paul-moore.com

