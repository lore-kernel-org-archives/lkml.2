Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2CCOEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 09:04:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63897 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2CCOEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 09:04:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arnaldo.melo@gmail.com designates 10.236.181.233 as permitted sender) smtp.mail=arnaldo.melo@gmail.com; dkim=pass header.i=arnaldo.melo@gmail.com
Date: Sat, 3 Mar 2012 11:04:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: perf_guest default bug
Message-ID: <20120303140405.GB16301@infradead.org>
References: <4F5118B1.5070406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5118B1.5070406@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 02, 2012 at 12:00:01PM -0700, David Ahern escreveu:
> Similar to my last email, this patch is not in urgent trees or
> Linus' yet the problem exists in Linus' tree:
> https://lkml.org/lkml/2012/2/17/82
> 
> $ /tmp/pbuild/perf record -a  -- sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.319 MB perf.data (~13935 samples) ]
> Segmentation fault
> 
> Root cause is the perf_guest setting.
> 
> $ /tmp/pbuild/perf --version
> perf version 3.3.rc5.60.g203738

This one was tricky, IIRC, weren't follow up patches needed to plug some
extra problems?

- Arnaldo
