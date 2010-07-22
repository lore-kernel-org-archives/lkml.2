Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0GVQVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0GVQV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:21:29 -0400
Date: Thu, 22 Jul 2010 13:21:07 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: a.p.zijlstra@chello.nl, davem@davemloft.net, imunsie@au.ibm.com,
        linux-kernel@vger.kernel.org, mhiramat@redhat.com, mingo@elte.hu,
        paulus@samba.org
Subject: Re: Small perf optimization
Message-ID: <20100722162107.GP5222@ghostprotocols.net>
References: <201007221611.o6MGBnmW029378@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007221611.o6MGBnmW029378@hs20-bc2-1.build.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 22, 2010 at 12:11:49PM -0400, Ulrich Drepper escreveu:
> Before this bad practice of using arrays of string pointers to constant
> strings further spreads let's fix it.  With this change not only is the
> entire data associated with the arrays read-only, it also replaces a
> memory lookup with a trivial arithmetic operation.  The result is
> a smaller and faster binary.
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Thanks, applying to perf/core (i.e. for 2.6.36).

- Arnaldo
