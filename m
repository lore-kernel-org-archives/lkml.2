Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1AGDmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:42:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44324 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1AGDml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=veQRNftn1xWKaSdITdL2HphAY2VGNmr21IM59EKj0jRYbyUVAuRo5edhHYupl36ph3
         smWE7aA41NwrhvEelfQ/+/dcgpyi/JxRj/DKgEPZGYgtka0j4MFkh2Hig9WNJhkCdtEX
         MQiEJtYwOYVJaAW94/MYRf2ZEg7pYEYfwXzAM=
Date: Fri, 7 Jan 2011 01:42:34 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Pass whole attr to event selectors
Message-ID: <20110107034234.GA7931@ghostprotocols.net>
References: <1294369869.20563.19.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294369869.20563.19.camel@minggr.sh.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 07, 2011 at 11:11:09AM +0800, Lin Ming escreveu:
> Since commit 69aad6f1(perf tools: Introduce event selectors), only
> perf_event_attr::type and ::config are passed to event selector, which
> makes perf tool not work correctly.
> 
> For example, PEBS does not work because perf_event_attr::precise_ip is
> not passed to the syscall.

Right, thanks for the fix, Ingo, I'm adding this to my perf/core tree.

- Arnaldo
