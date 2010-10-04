Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0JDR5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:57:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:37772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab0JDR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:57:01 -0400
Date: Mon, 4 Oct 2010 14:56:54 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 36-rc5] perf browser ui segfault on 'a' for annotate
Message-ID: <20101004175654.GB4420@ghostprotocols.net>
References: <20100923201901.GE31726@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923201901.GE31726@gambetta>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 23, 2010 at 10:19:01PM +0200, Frederik Deweerdt escreveu:
> Hi Arnaldo,
> 
> There a typo in util/ui/browsers/hists.c that leads to a segfault when
> you press the 'a' key on a non-resolved symbol (plain hex address).
> 
> This is fixed by the patch below.

Thanks, applied!

- Arnaldo
