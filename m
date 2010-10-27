Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0J0SH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0J0SHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:07:55 -0400
Date: Wed, 27 Oct 2010 14:07:35 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
Message-ID: <20101027180735.GK4823@redhat.com>
References: <1286864080.7768.179.camel@yhuang-dev>
 <1286865071.2336.1478.camel@twins>
 <1286865447.7768.184.camel@yhuang-dev>
 <1286865629.2336.1490.camel@twins>
 <1286865923.7768.188.camel@yhuang-dev>
 <1286866193.2336.1503.camel@twins>
 <20101012135112.GE20436@basil.fritz.box>
 <1286892927.29097.42.camel@twins>
 <20101027164522.GA25738@redhat.com>
 <1288199324.3673.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288199324.3673.14.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 07:08:44PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-27 at 12:45 -0400, Don Zickus wrote:
> > I assume this is sorta of what Peter was looking for.
> 
> Yeah close, except the prio field of the various notification blocks
> need to get adjusted to preserve semantics.

Heh.  Of course.  Let me add that to.

Thanks,
Don
