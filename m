Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab2LTIjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:39:36 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64654 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2LTIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:39:28 -0500
X-AuditID: 9c93016f-b7cf2ae0000069e9-a2-50d2cebd237a
Date: Thu, 20 Dec 2012 17:39:25 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/3] perf x86: Add precise sysfs attribute
Message-ID: <20121220083925.GC3679@danjae>
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
 <1355929642-28392-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355929642-28392-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 04:07:21PM +0100, Jiri Olsa wrote:
> Adding sysfs precise attribute for cpu device (/sys/devices/cpu)
> to show the maximum value for perf event precise attribute.
> 
> This will be initialy used for automated precise event perf test
> and could be helpful otherwise. Arnaldo suggested to use this as
> a guide for default adding of precise attribute for HW events.

Although I'm not aware of which architectures support precise feature,
wouldn't it better putting this on architecture independent rather
than just for x86 with fallback routine returning 0?

Thanks,
Namhyung
