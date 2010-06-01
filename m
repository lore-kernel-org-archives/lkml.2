Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0FAUVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:21:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0FAUVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:21:23 -0400
Date: Tue, 1 Jun 2010 17:20:59 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Subject: Re: [PATCH] perf: add perfconfig option to specify buildid cache dir
Message-ID: <20100601202058.GD4093@ghostprotocols.net>
References: <4c055fb7.df0ce30a.5f0d.ffffae52@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c055fb7.df0ce30a.5f0d.ffffae52@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 01, 2010 at 09:25:01PM +0200, Stephane Eranian escreveu:
> This patch adds the ability to specify an alternate directory
> to store the buildid cache (buildids, copy of binaries). By
> default, it is hardcoded to $HOME/.debug. This directory
> contains immutable data. The layout of the directory is such
> that no conflicts in filenames are possible. A modification
> in a file, yields a different buildid and thus a different
> location in the subdir hierarchy.

There are some minor nits about coding style and that tolower part that
seems to be better suited for being in a separate patch with a separate
explanation as to why it is needed (is it really?), but yeah, that is a
worthy change and I'll test and merge it, thanks!

- Arnaldo
