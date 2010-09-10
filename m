Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0IJJGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:06:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50937 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab0IJJGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:06:18 -0400
Date: Fri, 10 Sep 2010 10:06:15 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warnings for static char
 that could be static const char
Message-ID: <20100910090615.GA3644@shadowen.org>
References: <1284056536.24986.182.camel@Joe-Laptop>
 <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
 <1284060106.24986.215.camel@Joe-Laptop>
 <AANLkTin+twU1y_C6jfNDXruuoVncEivRO=2=1Jg69Xe=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin+twU1y_C6jfNDXruuoVncEivRO=2=1Jg69Xe=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 03:24:14PM -0400, Mike Frysinger wrote:
> On Thu, Sep 9, 2010 at 15:21, Joe Perches wrote:
> > Add warnings for possible missing const uses of
> >        static char foo[] = "bar"
> >    that could be
> >        static const char foo[] = "bar"
> > and
> >        static const char *foo[] = {"bar", "baz"}
> >    that could be
> >        static const char * const foo[] = {"bar", "baz"}
> 
> guess you missed my last e-mail about not bothering checking the
> static or the contents :)
> 
> > +               if ($line =~ /\bconst\s+char\s*\*\s*(\w+)\s*\[\s*\]/) {
> -mike

Could you elucidate on that comment Mike, perhaps copy those comments
here.

-apw
