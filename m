Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0FDCQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:16:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:45548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0FDCQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:16:10 -0400
Date: Thu, 3 Jun 2010 23:15:51 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Subject: Re: [PATCH] perf: make annotate demangle symbols
Message-ID: <20100604021551.GE10469@ghostprotocols.net>
References: <4c07b323.2126e30a.6245.0e1e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c07b323.2126e30a.6245.0e1e@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 03, 2010 at 03:50:01PM +0200, Stephane Eranian escreveu:
> Perf report is demangling symbols but not annotate.
> The former uses internal demangling via libbdf or
> libiberty. The latter executes objdump which by default
> does not demangle symbols.
> 
> This patch adds the -C option to the objdump cmdline
> to enable symbol demangling.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks, Applied.

- Arnaldo
