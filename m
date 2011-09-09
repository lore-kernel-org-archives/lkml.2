Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab1IIR2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:28:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758672Ab1IIR2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:28:30 -0400
Date: Fri, 9 Sep 2011 14:28:12 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH] perf: fix issue with binaries using 16-bytes buildids
	(v2)
Message-ID: <20110909172812.GA13072@ghostprotocols.net>
References: <4cc1af3c.8ee7d80a.5a28.ffff868e@mx.google.com> <CABPqkBTvz+WCDCknMn4wzr8LU__N199qaPqKH43q6EHadDKQSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTvz+WCDCknMn4wzr8LU__N199qaPqKH43q6EHadDKQSg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 09, 2011 at 07:03:12PM +0200, Stephane Eranian escreveu:
> Arnaldo,
> 
> To my surprise, this patch from Last October is STILL not in.
> People are reporting issues with perf related to md5 buildids..

Got it now, thanks for resubmitting, will appear on perf/urgent as soon
as things normalize on kernel.org.

- Arnaldo

- Arnaldo
