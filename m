Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1CIO0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:26:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:49952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab1CIO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:26:15 -0500
Date: Wed, 9 Mar 2011 11:25:56 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, phan@redhat.com
Subject: Re: [PATCH 1/2] perf,top: fix events overflow in top command
Message-ID: <20110309142556.GC20188@ghostprotocols.net>
References: <1299528821-17521-1-git-send-email-jolsa@redhat.com>
 <1299528821-17521-2-git-send-email-jolsa@redhat.com>
 <20110309135925.GA20188@ghostprotocols.net>
 <20110309140610.GB20188@ghostprotocols.net>
 <20110309141910.GB1929@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309141910.GB1929@jolsa.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 09, 2011 at 03:19:10PM +0100, Jiri Olsa escreveu:
> On Wed, Mar 09, 2011 at 11:06:10AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Mar 09, 2011 at 10:59:25AM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Good catch, applying to perf/urgent.
> > 
> > Tried but it doesn't apply nor can I reproduce the overflow (albeit
> > granted the long line of events is annoying).
> 
> patches were based on tip tree
> 
> hm, it crashes for me on tip tree,
> but I haven't checked the perf/core tree..
> 
> not sure if it's any help, but while debugging I could see the sigsegv happened
> when the pointer was far beyond the 160 chars buffer size,
> maybe the buffer got bigger in the perf tree..

Anyway, using tip/master you are using perf/core so the patch was made
against it, I already merged it, will be on my next pull request to
Ingo.

Thanks,

- Arnaldo
