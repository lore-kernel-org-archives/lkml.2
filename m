Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2GDLlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2GDLlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:41:14 -0400
Date: Wed, 4 Jul 2012 13:40:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] perf, tool: Fix pmu object initialization
Message-ID: <20120704114042.GB960@krava.redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
 <1341352848-11833-3-git-send-email-jolsa@redhat.com>
 <1341397848.2507.93.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341397848.2507.93.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 12:30:48PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> > The internal pmu list was never used. With each perf_pmu__find() call
> > the pmu structure was created new by parsing sysfs. Beside this it
> > caused memory leaks. We now keep all pmus by adding them to the list.
> > 
> > Also, pmu_lookup() should return pmus that do not expose the format
> > specifier in sysfs.
> > 
> > We need a valid internal pmu list in a later patch to iterate over all
> > pmus that exist in the system.
> > 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > [ added same treatment for 'event' sysfs group attribute ]
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com> 
> 
> Are we missing a From: ?

so first SOB is not enough then.. I'll add it in next version

jirka
> 
