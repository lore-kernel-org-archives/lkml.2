Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729Ab0HLSUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:20:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0HLSUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:20:17 -0400
Date: Thu, 12 Aug 2010 15:20:00 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        fweisbec@gmail.com, peterz@infradead.org
Subject: Re: [PATCH] perf trace: get rid of the hard-coded paths in the
 report scripts
Message-ID: <20100812182000.GD21829@ghostprotocols.net>
References: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 12, 2010 at 12:59:18PM -0500, Tom Zanussi escreveu:
> The perf trace report shell scripts hard-code the exec path of the
> scripts into their command-lines, which doesn't work if perf has been
> installed somewhere else.
> 
> Instead, perf trace should create the paths at run-time.  This patch
> does that and removes the hard-coded paths from all the report scripts.
> 
> v2 changes: The first version inadvertantly caused scripts run from
> outside the perf exec path to fail e.g. 'perf trace -s test.py'.  The
> fix is to try the script name without the exec path first, then the
> version using the exec path, which restores the expected behavior.
> 
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

Stephane,

	Lemme know when you tried this patch so that I can merge it with
a Tested-by: you tag, ok?

- Arnaldo
