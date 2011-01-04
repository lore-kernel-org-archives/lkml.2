Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1ADPpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:45:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1ADPpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:45:07 -0500
Date: Tue, 4 Jan 2011 13:44:39 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
Subject: Re: [PATCH] perf: fix perf_event.h header usage
Message-ID: <20110104154439.GA26167@ghostprotocols.net>
References: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 04, 2011 at 04:30:01PM +0200, Stephane Eranian escreveu:
> This patch fixes the usage of the perf_event.h header file
> between command modules and the supporting code in util.
> 
> It is necessary to ensure that ALL files use the SAME
> perf_event.h header from the kernel source tree.
> 
> There were a couple of #include <linux/perf_event.h> mixed
> with #include "../../perf_event.h".
> 
> This caused issues on some distros because of mismatch
> in the layout of struct perf_event_attr. That eventually
> led perf stat to segfault.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks, applying.

- Arnaldo
