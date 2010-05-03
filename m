Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab0ECNXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:23:34 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:41694 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab0ECNXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=ONkNGaLpfBGzDPsfbtcYZucagAbhl7grVTTVYZIqOS+5jCrpooL8rHMamxdyBuY0Xh
         cpr+LuTuIClJEI6s8VNSVyZHOEhoWYA27n4vdwgXNd0mvRbg9aF5Yq+aYyAKEyg+SWLU
         hvzjoWMarCQVI+/Z8Jl/nD0vJeIgYb5culcWw=
Date: Mon, 3 May 2010 10:23:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/5] perf record: Don't exit in live mode when no
 tracepoints are enabled
Message-ID: <20100503132325.GA970@ghostprotocols.net>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
 <1272841142-26029-5-git-send-email-acme@infradead.org>
 <1272865861.7932.16.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272865861.7932.16.camel@tropicana>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 03, 2010 at 12:51:01AM -0500, Tom Zanussi escreveu:
> Hi,
> 
> 
> Thanks for taking these patches and fixing them up!
> 
> BTW, I posted a patch a couple days ago that also fixes this problem, in
> response to a bug report for a non-live-mode problem seen when using
> SAMPLE_RAW with no tracepoints:
> 
> http://lkml.org/lkml/2010/5/1/2
> 
> Here it is again, fixed up to apply to your tree...

Thanks, applying it.

- Arnaldo
