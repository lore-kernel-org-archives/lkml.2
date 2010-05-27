Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0E0Ppn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:45:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab0E0PpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:45:23 -0400
Date: Thu, 27 May 2010 12:45:11 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: fix use_browser infinite loop bug in annotate
Message-ID: <20100527154510.GK9874@ghostprotocols.net>
References: <4bfe6b18.914ed80a.0573.4c6e@mx.google.com>
 <20100527145142.GJ9874@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100527145142.GJ9874@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 27, 2010 at 11:51:42AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, May 27, 2010 at 02:50:01PM +0200, Stephane Eranian escreveu:
> > This patch fixes an infinite loop problem with perf annotate when
> > the TUI is not used. When the perfconfig file is not found use_browser
> > remains at -1, when found and tui is disabled use_browser = 0. Thus the
> > correct test for TUI is use_browser > 0.
> > 
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> Thanks, I'm applying this one and doing an audit of other uses, I know
> of one more case reported by Frédéric that was fixed in a similar way.

	Oops, I already have this fixed on changeset

62e3436b5f3461662929eae102beefbd12127cb1

	That is at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commit;h=62e3436b5f3461662929eae102beefbd12127cb1
 
	I pushed this to Ingo yesterday, should be in tip/perf/core soon,
thanks anyway!

- Arnaldo
