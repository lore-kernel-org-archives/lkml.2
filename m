Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2HMRg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:36:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61288 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2HMRg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:36:28 -0400
Date: Mon, 13 Aug 2012 14:36:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 11/16] perf symbol: introduce symsrc structure.
Message-ID: <20120813173620.GA6840@infradead.org>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
 <1344637382-22789-12-git-send-email-cody@linux.vnet.ibm.com>
 <1344691689.2003.11.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1344691689.2003.11.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 11, 2012 at 10:28:09PM +0900, Namhyung Kim escreveu:
> 2012-08-10 (금), 15:22 -0700, Cody P Schafer:
> > +++ b/tools/perf/util/symbol.h
> > @@ -11,6 +11,12 @@
> >  #include <stdio.h>
> >  #include <byteswap.h>
> >  
> > +#ifndef NO_LIBELF
> 
> Should be NO_LIBELF_SUPPORT.
> 
> > +struct symsrc {
> > +	char *name;
> > +	int fd;
> > +	enum dso_binary_type type;
> > +
> > +#ifndef NO_LIBELF
> 
> Ditto.

Thanks, I fixed those,

- Arnaldo
