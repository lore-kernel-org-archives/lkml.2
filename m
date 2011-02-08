Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1BHDio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:38:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44389 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1BHDin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=N+EfuVOTcytAEL23RBlKPLBIDPbdwkVjRb4tRa01HVCf6nZYtQ9eevHqt1v3uzhVYe
         FD9JprIFdFGxs7pKXqEUUHRWy2E29hr+C3RP4IfzZBqQ7xF4H0buE8Pn514z9d8knKcI
         DxEb0um7Cek+ShuRBEUaX8XxcL1rNbqcdzIH0=
Date: Tue, 8 Feb 2011 11:38:21 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, davem@davemloft.net,
        joe@perches.com, akpm@linux-foundation.org, greg@kroah.com
Subject: [PATCH]Maintain Chinese Documentations
Message-ID: <20110208033818.GA4922@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
	davem@davemloft.net, joe@perches.com, akpm@linux-foundation.org,
	greg@kroah.com
References: <20110208023735.GA4599@gmail.com>
 <20110207184027.468e2a03.rdunlap@xenotime.net>
 <AANLkTimacOStZv-hrxo6iOWUDNem+h1cmaKCZQzw=0jr@mail.gmail.com>
 <20110208031638.GA4828@gmail.com>
 <20110207192249.5a478469.rdunlap@xenotime.net>
 <AANLkTimFFT-B_aPyfFJmMpvt9jhd98ckBah2vbK+WQJf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimFFT-B_aPyfFJmMpvt9jhd98ckBah2vbK+WQJf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:26:43AM +0800, harryxiyou wrote:
> ---------- Forwarded message ----------
> From: Randy Dunlap <rdunlap@xenotime.net>
> Date: 2011/2/8
> Subject: Re: [PATCH]Maintain Chinese Documentations
> To: Harry Wei <jiaweiwei.xiyou@gmail.com>
> Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe@perches.com,
> akpm@linux-foundation.org, greg@kroah.com
> 
> 
> > > Hi Harry,
> 
> a.  Omit my previous comments, just make a new patch with description.
> 
> b.  This line:
> +F:     Documentation/zh_CN
> 
> should have a trailing '/' on it to indicate that it is a directory.
> 
> c.  After
> > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> 
> you can add this line:
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>
Hi Randy,
So thanks to your help.
I correct it like following :)

Thanks.
Best Regards.
Harry Wei.


Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dc0279e..afb6f7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1692,6 +1692,12 @@ M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
 F:	scripts/checkpatch.pl
 
+CHINESE DOCUMENTATION
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	xiyoulinuxkernelgroup@googlegroups.com
+S:	Maintained
+F:	Documentation/zh_CN/
+
 CISCO VIC ETHERNET NIC DRIVER
 M:	Vasanthy Kolluri <vkolluri@cisco.com>
 M:	Roopa Prabhu <roprabhu@cisco.com>
-- 
1.7.0.4

> 
> Thanks.
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!
