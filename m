Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1FCS7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:59:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab1FCS7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:59:24 -0400
Date: Fri, 3 Jun 2011 15:59:11 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH] perf: make annotate more readable
Message-ID: <20110603185911.GB23336@ghostprotocols.net>
References: <20110517153207.GA9834@quad> <20110603185633.GA23336@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603185633.GA23336@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 03, 2011 at 03:56:33PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, May 17, 2011 at 05:32:07PM +0200, Stephane Eranian escreveu:
> > 
> > This patch adds two new options to perf annotate:
> > 	- -R, --no-asm-raw : do not display raw instruction encodings
> > 	- -S, --no-source  : do not interleave source code with assembly code
> > 
> > We believe those options make the output of annotate more readable.
> > Systematically displaying source can make it hard to follow code and
> > especially optimized code.
> > 
> > Raw encodings are not useful in most cases.
> 
> Ok, applying it and then adding a followup patch to have these new
> options in both 'perf top' and 'perf report', since you can do
> annotation (live and static, respectively) from those tools.

Will change it to --source and --asm-raw, since we have logic to negate
any option by adding "no-" after '--' and before boolean options.

- Arnaldo
