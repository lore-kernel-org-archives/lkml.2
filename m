Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2KMAY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:24:29 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18900 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab2KMAY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:24:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYVANmRoVB5LErT/2dsb2JhbABEvWWEdgOBBIEJgh4BAQU6HCMQCAMOCi4UJQMhE4gJqW+QLhSMAWwxhExhA5V7iUmGe4MDgVAX
Date: Tue, 13 Nov 2012 11:24:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: Use bool type rather than a custom boolean_t type.
Message-ID: <20121113002420.GC25039@dastard>
References: <CACnwZYdPntxqWh_Hb2=fa4NPFhtZQSj-sRK3hMHcK6FdctQEXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACnwZYdPntxqWh_Hb2=fa4NPFhtZQSj-sRK3hMHcK6FdctQEXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 09:36:17PM -0200, Thiago Farina wrote:
> Hi,
> 
> Please, take a look.
> 
> Patch attached.

It's a good start for a cleanup, but there's no point in removing
the boolean_t from one file and then not removing it from the rest
of the XFS code.  It's only used in a handful of places, so just
remove it completely.

Also, can you please place patches in line rather than attaching
them. Attaching them means they cannot be quoted in reply. See
Documentation/SubmittingPatches and Documentation/email-clients.txt
for guidelines.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
