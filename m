Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab2IHPNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:13:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65168 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2IHPM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:12:59 -0400
Date: Sat, 8 Sep 2012 08:12:53 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/12] perf diff: Refactor stdio ui data columns output
Message-ID: <20120908151253.GJ20401@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-6-git-send-email-jolsa@redhat.com>
 <878vcmczjt.fsf@sejong.aot.lge.com>
 <20120908123514.GA3408@krava.brq.redhat.com>
 <20120908125059.GG20401@ghostprotocols.net>
 <871uica8d0.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uica8d0.fsf@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Sep 08, 2012 at 11:37:31PM +0900, Namhyung Kim escreveu:
> On Sat, 8 Sep 2012 05:50:59 -0700, Arnaldo Carvalho de Melo wrote:
> > well, you can, but that one is buggy and you will not be able to test
> > 'perf diff' at all...
> 
> I posted the fix right before, and you will also need patch below for
> fixing broken "baseline" output.
> 
Trying to figure out when to apply this patch, as it should fix the
problem one experiences right after applying the first patch of your
series plus the small fix you sent before this one, and it is not
applying...

- Arnaldo
