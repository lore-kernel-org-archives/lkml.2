Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab2EWRNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:13:22 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37441 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2EWRNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:13:21 -0400
Date: Wed, 23 May 2012 14:13:14 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf build failure in v3.4-4842-g61011677
Message-ID: <20120523171314.GA1687@infradead.org>
References: <20120523141359.GE1143@zod.bos.redhat.com>
 <20120523143304.GF1143@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120523143304.GF1143@zod.bos.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 23, 2012 at 10:33:05AM -0400, Josh Boyer escreveu:
> OK, seems Steven fixed the trace-event-python.c file with commit
> aaf045f7233, but missed the perl one.  This patch seems to fixup the
> errors.

I reported this to Frédéric, that fixed it, I merged on my perf/core
branch, that Ingo already pulled, thanks anyway,

- Arnaldo
