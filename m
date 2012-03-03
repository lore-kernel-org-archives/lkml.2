Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2CCN7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 08:59:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64291 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2CCN7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 08:59:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arnaldo.melo@gmail.com designates 10.236.174.106 as permitted sender) smtp.mail=arnaldo.melo@gmail.com; dkim=pass header.i=arnaldo.melo@gmail.com
Date: Sat, 3 Mar 2012 10:59:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: no build option fails in kerneltip
Message-ID: <20120303135943.GA16301@infradead.org>
References: <4F5115DA.5000001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5115DA.5000001@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 02, 2012 at 11:47:54AM -0700, David Ahern escreveu:
> Hi Arnaldo:
> 
> I noticed this patch is not in Linus' tree or your perf-urgent (only
> your perf-core): https://lkml.org/lkml/2012/2/6/415
> 
> Yet, the problem is in Linus' tip:
> 
> $ /tmp/pbuild/perf record -a -BN -- sleep 1
> Couldn't generating buildids. Use --no-buildid to profile anyway.
> sleep: Terminated
> 
> $ /tmp/pbuild/perf --version
> perf version 3.3.rc5.60.g203738

Its in tip/perf/core as well, I'll cherry pick it into my perf/urgent
branch since it fixes a problem you found upstream.

- Arnaldo
