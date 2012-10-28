Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2J1TNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:13:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35813 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab2J1TNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:13:14 -0400
Date: Sun, 28 Oct 2012 20:13:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, eranian@google.com,
        mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 27/33] tools, perf: Add a precise event qualifier
Message-ID: <20121028191313.GP16230@one.firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org> <1351283415-13170-28-git-send-email-andi@firstfloor.org> <20121027193544.GC1039@krava.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121027193544.GC1039@krava.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 09:35:44PM +0200, Jiri Olsa wrote:
> On Fri, Oct 26, 2012 at 01:30:09PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add a precise qualifier, like cpu/event=0x3c,precise=1/
> hm, I think this works already via 'p' modifier like:
>    cpu/event=0x3c/p

Not for kernel specified events, which is why this was needed.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
