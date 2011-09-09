Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1IIATC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:19:02 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33701 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab1IIATA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:19:00 -0400
Date: Fri, 9 Sep 2011 09:18:53 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Message-ID: <20110909001853.GA29319@htj.dyndns.org>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Thu, Sep 08, 2011 at 06:50:01PM +0200, Denys Vlasenko wrote:
> Consider what will happen when a next ptrace fix will require
> a way to change ptrace API at runtime. A new option will likely
> be introduced, say, PTRACE_O_TRACEPONY, with next available
> bit position 7, and perhaps some new event will be generated,
> PTRACE_EVENT_PONY, with value.... yes, it can't be 7,
> PTRACE_EVENT_STOP took it. So it will probably be 8.

Then, just give it the next matching number.

If options naturally happen to match the events, that's a nice
coincidence.  If the real life requirement deviates from the beautiful
one-to-one mapping, then, so be it.  No, the magical contiguous one to
one mapping isn't the most important design concern.

To me, the rationale presented here almost argues against
PTRACE_O_TRACESTOP.  :(

Thanks.

-- 
tejun
