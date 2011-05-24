Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab1EXUhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:37:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49619 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1EXUhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:37:15 -0400
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris McDermott <lcm@linux.vnet.ibm.com>
In-Reply-To: <20110524130700.079b09e8.akpm@linux-foundation.org>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com>
	 <1302557371.7286.16607.camel@nimitz>
	 <20110412100129.43F1.A69D9226@jp.fujitsu.com>
	 <1302575241.7286.17853.camel@nimitz>
	 <20110524130700.079b09e8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 24 May 2011 13:37:04 -0700
Message-ID: <1306269424.22505.20.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 13:07 -0700, Andrew Morton wrote:
> On Mon, 11 Apr 2011 19:27:21 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > I'll go try and dig for some more specifics on the hardware so we at
> > least have something to test on.
> 
> How's that digging coming along?
> 
> I'm pretty wobbly about this patch.  Perhaps we should set
> RECLAIM_DISTANCE to pi/2 or something, to force people to correctly set
> the dang thing in initscripts.

The original change in the hardware tables was for the benefit of a
benchmark.  Said benchmark isn't going to get run on mainline until the
next batch of enterprise distros drops, at which point the hardware
where this was done will be irrelevant for the benchmark.  I'm sure any
new hardware will just set this distance to another yet arbitrary value
to make the kernel do what it wants. :)

Also, when the hardware got _set_ to this initially, I complained.  So,
I guess I'm getting my way now, with this patch.  I'm cool with it:

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

