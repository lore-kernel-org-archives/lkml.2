Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2J1UGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:06:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:40931 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab2J1UGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,667,1344236400"; 
   d="scan'208";a="210452945"
Date: Sun, 28 Oct 2012 13:06:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, eranian@google.com,
        mingo@kernel.org
Subject: Re: [PATCH 27/33] tools, perf: Add a precise event qualifier
Message-ID: <20121028200603.GG2266@tassilo.jf.intel.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-28-git-send-email-andi@firstfloor.org>
 <20121027193544.GC1039@krava.redhat.com>
 <20121028191313.GP16230@one.firstfloor.org>
 <20121028192449.GD1599@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121028192449.GD1599@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 08:24:49PM +0100, Jiri Olsa wrote:
> On Sun, Oct 28, 2012 at 08:13:13PM +0100, Andi Kleen wrote:
> > On Sat, Oct 27, 2012 at 09:35:44PM +0200, Jiri Olsa wrote:
> > > On Fri, Oct 26, 2012 at 01:30:09PM -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > Add a precise qualifier, like cpu/event=0x3c,precise=1/
> > > hm, I think this works already via 'p' modifier like:
> > >    cpu/event=0x3c/p
> > 
> > Not for kernel specified events, which is why this was needed.
> 
> I haven't checked deeply, but I thought the modifier is always
> applied, what do you mean by 'kernel specified events' ?

Events exported in sysfs.

See the earlier patches in the patchkit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
