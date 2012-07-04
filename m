Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab2GDKbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:31:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50906 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab2GDKbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:31:00 -0400
Subject: Re: [PATCH 02/10] perf, tool: Fix pmu object initialization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341352848-11833-3-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:30:48 +0200
Message-ID: <1341397848.2507.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> The internal pmu list was never used. With each perf_pmu__find() call
> the pmu structure was created new by parsing sysfs. Beside this it
> caused memory leaks. We now keep all pmus by adding them to the list.
> 
> Also, pmu_lookup() should return pmus that do not expose the format
> specifier in sysfs.
> 
> We need a valid internal pmu list in a later patch to iterate over all
> pmus that exist in the system.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> [ added same treatment for 'event' sysfs group attribute ]
> Signed-off-by: Jiri Olsa <jolsa@redhat.com> 

Are we missing a From: ?

