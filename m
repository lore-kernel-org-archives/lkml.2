Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1GNNuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:50:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54241 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1GNNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:50:16 -0400
Date: Thu, 14 Jul 2011 15:50:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Soeren Sandmann Pedersen <ssp@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, x86 <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/2] x86: Remove warning and warning_symbol from struct
 stacktrace_ops
Message-ID: <20110714135006.GA26786@somewhere.redhat.com>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
 <1305232326-9804-2-git-send-email-fweisbec@gmail.com>
 <20110714110102.GT7529@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714110102.GT7529@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 12:01:02PM +0100, Mel Gorman wrote:
> On Thu, May 12, 2011 at 10:32:05PM +0200, Frederic Weisbecker wrote:
> > From: Richard Weinberger <richard@nod.at>
> > 
> > Both warning and warning_symbol are nowhere used.
> > Let's get rid of them.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Huang Ying <ying.huang@intel.com>
> > Cc: Soeren Sandmann Pedersen <ssp@redhat.com>
> > Cc: Namhyung Kim <namhyung@gmail.com>
> > Cc: x86 <x86@kernel.org>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Robert Richter <robert.richter@amd.com>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > Link: http://lkml.kernel.org/r/1305205872-10321-2-git-send-email-richard@nod.at
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> This change breaks systemtap. I know it's out of tree and systemtap
> doesn't even do anything useful with the symbols as it assigns them
> to dummy callbacks but the breakage is there.

Then it's up to systemtap developers to deal with that. We don't maintain out-of-tree.
