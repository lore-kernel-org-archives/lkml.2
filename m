Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0G2XBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:01:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60750 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0G2XBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:01:10 -0400
Date: Thu, 29 Jul 2010 16:00:52 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
        Daniel Lezcano <dlezcano@free.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Remaining work for userns (WAS Re: [PATCH 3/3] cgroup : remove the
 ns_cgroup)
Message-ID: <20100729230052.GB2785@count0.beaverton.ibm.com>
References: <20100729195629.GA13378@hallyn.com>
 <20100729195812.GB19015@hallyn.com>
 <20100729214008.GA2785@count0.beaverton.ibm.com>
 <20100729223957.GA12387@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729223957.GA12387@hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 05:39:57PM -0500, Serge E. Hallyn wrote:
> Quoting Matt Helsley (matthltc@us.ibm.com):
> > On Thu, Jul 29, 2010 at 02:58:12PM -0500, Serge E. Hallyn wrote:

<snip>

> 
> BTW in the past the only reason I saw for keeping ns cgroup was
> to lock tasks into a devices cgroup.  Until that lazy guy who was
> going to do it gets off his butt and implements user namespaces,
> you'll just have to use LSMs, which is the right way.

And the only missing piece of userns is replacing the cred checks
right? If so, it might be possible to come up with a coccinelle semantic
patch which would do all/most of the hard work -- depends on whether the
all the checks fit a small number of semantic patterns.

Cheers,
	-Matt Helsley
