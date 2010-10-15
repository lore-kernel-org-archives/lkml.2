Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0JOPiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:38:24 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:50497 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350Ab0JOPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:38:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAM4QuEx5Ld+3/2dsb2JhbACDH54Ccq1rkjuBIoMzdASPSg
Date: Sat, 16 Oct 2010 02:38:17 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015153817.GA7796@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015040406.GA6930@amd>
 <20101015113336.GH4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101015113336.GH4681@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:33:36PM +1100, Dave Chinner wrote:
> So, Nick, please, either help us get the code into a form acceptible
> to the VFS maintainers and into mainline, or stay out of the way
> while we go through the process as quickly as we can. This requireѕ
> a co-ordinated group effort, so arguing is really quite
> counter-productive. I'd prefer that you help us get through the
> process by being constructive and reviewing and testing and keeping
> us honest.

This exact same statement applies to you, from me. We all know
how to cooperate, and forking a new tree because the maintainer
goes away for a few weeks (and you suddenly get interested after
all this time) is not the right way to do it.

Frankly if your attitude is now demanding that I cooperate with
you, then I'm actually quite happy to just go over your head.

