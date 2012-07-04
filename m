Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250Ab2GDKjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:39:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52218 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab2GDKjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:39:42 -0400
Subject: Re: [PATCH 07/10] perf, tool: Add support to specify hw event as
 pmu event term
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341352848-11833-8-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-8-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:39:20 +0200
Message-ID: <1341398360.2507.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> 
> It's possible to use sysfs attribute name as 'event' term value,
> or any possible alias for hw event, e.g.:
>   cycles                     OR cpu-cycles
>   branch_misses              OR branch-misses
>   bus_cycles                 OR bus-cycles
>   cache_misses               OR cache-misses
>   cache_references           OR cache-references
>   ref_cycles                 OR ref-cycles
>   stalled_cycles_backend     OR stalled-cycles-backend
>   stalled_cycles_frontend    OR stalled-cycles-frontend 

Do we really want to do that?

