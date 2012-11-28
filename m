Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2K1P6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:58:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2K1P6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:58:48 -0500
Date: Wed, 28 Nov 2012 16:57:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH/RFC 00/14] perf, diff: Support for multiple files
Message-ID: <20121128155752.GG1038@krava.brq.redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
 <20121128135655.GC1038@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128135655.GC1038@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 02:56:55PM +0100, Jiri Olsa wrote:
> aargh.. fixed subject.. copy&paste error ;-)
> 
> also patches are available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
> perf/multi2

worked out some fixies with Arnaldo, new version is here:

git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/multi3

thanks,
jirka
