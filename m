Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2IHPVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:21:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56485 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2IHPVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:21:30 -0400
Date: Sat, 8 Sep 2012 08:21:24 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/12] perf diff: Refactor stdio ui data columns output
Message-ID: <20120908152124.GK20401@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-6-git-send-email-jolsa@redhat.com>
 <878vcmczjt.fsf@sejong.aot.lge.com>
 <20120908123514.GA3408@krava.brq.redhat.com>
 <20120908125059.GG20401@ghostprotocols.net>
 <871uica8d0.fsf@kernel.org>
 <20120908151253.GJ20401@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908151253.GJ20401@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Sep 08, 2012 at 08:12:53AM -0700, Arnaldo Carvalho de Melo escreveu:
> Trying to figure out when to apply this patch, as it should fix the
> problem one experiences right after applying the first patch of your
> series plus the small fix you sent before this one, and it is not
> applying...

Ok, I think I figured it out, results now are the same and I'll proceed
to the next patches.

- Arnaldo
