Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1HHNDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:03:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1HHNDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:03:31 -0400
Date: Mon, 8 Aug 2011 15:03:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>
Subject: Re: regarding [PATCH] Add libpfm4 support (v3)
Message-ID: <20110808130309.GA4618@jolsa.brq.redhat.com>
References: <20110808120432.GB2076@jolsa.brq.redhat.com>
 <1312806326.10488.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312806326.10488.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 02:25:25PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-08 at 14:04 +0200, Jiri Olsa wrote:
> > hi,
> > 
> > any chance of getting this included?
> > http://article.gmane.org/gmane.comp.linux.perfmon2.devel/2912
> > http://article.gmane.org/gmane.comp.linux.perfmon2.devel/2912/raw
> > 
> > it needs just some little changes to fit to current tip tree
> 
> While I don't mind extending the current way to input events I don't
> think using libpfm4 for it is desired.
> 
> One of the ideas that has been floating about is to provide a format
> file in the sysfs representation of the pmu. This format file would
> describe the config space. The tool would parse this and use it to
> provide better input capabilities.
> 
> This is not an easy task however, since the format syntax needs to be
> capable enough to describe all the various config muck we need to
> support, think for example of the P4 mess.
> 
> For Intel/AMD (excluding P4) its mostly simple, with Intel having a
> slightly harder time for the offcore bits.
> 
> As to the various arch event lists, again that is not something we need
> a whole library for, parsing those text files isn't hard. Maintaining
> the various arch event lists in a sane format is the 'hard' part and is
> something I think we should push to the vendors, because they're
> basically the only ones capable.
ok, understood

thanks,
jirka
