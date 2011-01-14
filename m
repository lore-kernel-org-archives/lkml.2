Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1ANRi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:38:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:38267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1ANRiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:38:22 -0500
Date: Fri, 14 Jan 2011 15:37:40 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf timechart broken
Message-ID: <20110114173739.GA29318@ghostprotocols.net>
References: <201101071104.37576.trenn@suse.de>
 <20110111114951.GA8564@ghostprotocols.net>
 <20110111145134.GA11968@ghostprotocols.net>
 <201101141749.36716.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101141749.36716.trenn@suse.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 14, 2011 at 05:49:36PM +0100, Thomas Renninger escreveu:
> On Tuesday 11 January 2011 15:51:34 Arnaldo Carvalho de Melo wrote:
> > Em Tue, Jan 11, 2011 at 09:49:51AM -0200, Arnaldo Carvalho de Melo escreveu:
> > > Looking at it now.
> > 
> > Can you try with this patch applied? We need a better way of specifying
> > ordering of __exit and __init routines :-\
> I tested on x86/tip and it is fixed.
> I explicitly reverted your fix and run into it again.
> 
> Thanks!

Thanks a lot for reporting and retesting,

- Arnaldo
