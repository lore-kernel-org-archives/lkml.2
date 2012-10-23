Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2JWLns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:43:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35461 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2JWLnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:43:47 -0400
Date: Tue, 23 Oct 2012 13:43:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stephane Eranian <eranian@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, stat: Add --pre and --post command
Message-ID: <20121023114342.GB29010@gmail.com>
References: <1350992414.13456.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350992414.13456.5.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> In order to measure kernel builds, one has to do some pre/post cleanup
> work in order to do the repeat build.
> 
> So provide --pre and --post command hooks to allow doing just that.
>   
>   perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/ clean' -- make -s -j64 O=defconfig-build/ bzImage
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

looks useful!

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
