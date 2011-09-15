Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab1IOO6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab1IOO6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:58:32 -0400
Date: Thu, 15 Sep 2011 11:53:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf: add support for disabling -Werror via WERROR=0
Message-ID: <20110915145315.GD25658@ghostprotocols.net>
References: <eac06c7cc4920e5d4830417d466161fb26c7359c.1315514559.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac06c7cc4920e5d4830417d466161fb26c7359c.1315514559.git.dvhart@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 08, 2011 at 01:42:39PM -0700, Darren Hart escreveu:
> GCC often introduces new warnings with lots of false positives - breaking
> -Werror builds. WERROR=0 allows one to build perf without much fuss - while
> still encouraging people to send patches to avoid the fuss of having to type
> WERROR=0.
> 
> Bisecting back to commits that produce a (mostly harmless) warning on some
> compilers is more difficult. With WERROR=0 one could bisect without worrying
> about harmless warnings.

Thanks, I put it in my perf/urgent branch in:

https://github.com/acmel/linux/commit/d8075f711858fce568e37453c1dd5e2b6f18504c

- Arnaldo
