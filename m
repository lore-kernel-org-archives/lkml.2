Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2IFNvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:51:46 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:47036 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2IFNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:51:45 -0400
Date: Thu, 6 Sep 2012 06:51:38 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/2] perf header: Prepare tracepoint events regardless of
 name
Message-ID: <20120906135137.GJ8203@ghostprotocols.net>
References: <1346897446-16569-1-git-send-email-namhyung@kernel.org>
 <1346897446-16569-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346897446-16569-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 06, 2012 at 11:10:46AM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Current perf_evlist__set_tracepoint_names is a misnomer because it
> finds and sets correspoding event_format in addition to the name.  So
> skipping it when a event has set name already caused a trouble.
> 
> Rename it and set name only a event doesn't have one.
> 
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
> Arnaldo, I made it incremental for your convenience.  But if you want
> to drop my previous one I can resend with it.  Please let me know your
> preference. :)

I applied this 2-patch series now, thanks.

- Arnaldo
