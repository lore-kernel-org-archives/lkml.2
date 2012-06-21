Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2FUHHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:07:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:34799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab2FUHHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="160441010"
Date: Thu, 21 Jun 2012 10:08:37 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Docs: printk-formats: add description for %pMR
Message-ID: <20120621070827.GA9341@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>
References: <1338210316-12299-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1340189089-20257-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <20120620141957.d865133a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620141957.d865133a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 20, 2012 at 02:19:57PM -0700, Andrew Morton wrote:
> > --- a/Documentation/printk-formats.txt
> > +++ b/Documentation/printk-formats.txt
> > @@ -56,6 +56,7 @@ Struct Resources:
> >  MAC/FDDI addresses:
> >  
> >  	%pM	00:01:02:03:04:05
> > +	%pMR	05:04:03:02:01:00
> >  	%pMF	00-01-02-03-04-05
> >  	%pm	000102030405
> >  
> > @@ -67,6 +68,10 @@ MAC/FDDI addresses:
> >  	the 'M' specifier to use dash ('-') separators instead of the default
> >  	separator.
> >  
> > +	For Bluetooth addresses the 'R' specifier shall be used after the 'M'
> > +	specifier to use reversed byte order suitable for visual interpretation
> > +	of Bluetooth addresses which are in the little endian order.
> > +
> 
> huh, I didn't know about that file, or I forgot about it.

This happens also to me.

> I wonder if it is otherwise up to date.
> Do we really need it?  

I feel that the document is very good.

> If we can sufficiently document the printk
> formats in lib/vsprintf.c then let's remove
> Documentation/printk-formats.txt.  

Until I read that vsprintf.c I did not know where to find printk format
specifiers. It does make sense to keep it.

> Otherwise, I shall do this:
> 
> 
> --- a/lib/vsprintf.c
> +++ a/lib/vsprintf.c
> @@ -1297,6 +1297,8 @@ qualifier:
>   *   case.
>   * %n is ignored
>   *
> + * ** Please update Documentation/printk-formats.txt when making changes **
> + *

Looks good.

Best regards 
Andrei Emeltchenko 

