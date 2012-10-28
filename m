Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2J1TZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab2J1TZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:25:04 -0400
Date: Sun, 28 Oct 2012 20:24:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 27/33] tools, perf: Add a precise event qualifier
Message-ID: <20121028192449.GD1599@krava.redhat.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-28-git-send-email-andi@firstfloor.org>
 <20121027193544.GC1039@krava.redhat.com>
 <20121028191313.GP16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121028191313.GP16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 08:13:13PM +0100, Andi Kleen wrote:
> On Sat, Oct 27, 2012 at 09:35:44PM +0200, Jiri Olsa wrote:
> > On Fri, Oct 26, 2012 at 01:30:09PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Add a precise qualifier, like cpu/event=0x3c,precise=1/
> > hm, I think this works already via 'p' modifier like:
> >    cpu/event=0x3c/p
> 
> Not for kernel specified events, which is why this was needed.

I haven't checked deeply, but I thought the modifier is always
applied, what do you mean by 'kernel specified events' ?

jirka
