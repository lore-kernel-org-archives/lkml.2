Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2ITNxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:53:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57587 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2ITNxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:53:23 -0400
Subject: Re: [PATCH 1/4] perf header: Add struct perf_header_info
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20120920114307.GB11325@ghostprotocols.net>
References: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
	 <1348119407-12528-2-git-send-email-namhyung@kernel.org>
	 <20120920114307.GB11325@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Sep 2012 22:53:16 +0900
Message-ID: <1348149196.1510.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-09-20 (목), 04:43 -0700, Arnaldo Carvalho de Melo:
> Em Thu, Sep 20, 2012 at 02:36:44PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > The struct perf_header_info will preserve environment information at
> > the time of perf record.  It can be accessed anytime after parsing a
> > perf.data file if needed.
>  
> > +struct perf_header_info {
> 
> I think it would be better named as 'perf_session_env' i.e. the
> environment (machine (name), hardware(nr_cpus, total_mem, etc) and
> OS(release, version) details) where a 'perf' 'session' took place.
> 
> perf 'header info' look more like 'what is the version in the header?
> what about its endianity, and other 'header' details :-)

Okay, will rename and resend tomorrow!

/me always failed to make a good name :(

Thanks,
Namhyung


