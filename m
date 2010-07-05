Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0GESmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:42:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0GESmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:42:39 -0400
Date: Mon, 5 Jul 2010 15:42:35 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Conny Seidel <conny.seidel@amd.com>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com
Subject: Re: [PATCH] perf tools: Fix fallback to cplus_demangle() when
 bfd_demangle() is not available
Message-ID: <20100705184234.GA3861@ghostprotocols.net>
References: <1278353250-28490-1-git-send-email-conny.seidel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278353250-28490-1-git-send-email-conny.seidel@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 05, 2010 at 08:07:30PM +0200, Conny Seidel escreveu:
> make version 3.80 doesn't support "else ifdef" on the same line, also it
> doesn't support unindented nested constructs.
> 
> Build fails with:
> Makefile:608: Extraneous text after `else' directive
> Makefile:611: *** only one `else' per conditional.  Stop.
> 
> This patch fixes the build for make 3.80.
> 
> Signed-off-by: Conny Seidel <conny.seidel@amd.com>

I got this on my tree, will push to Ingo after I get the perf probe
changes tested.

- Arnaldo
