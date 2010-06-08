Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab0FHWq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:46:59 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:34516 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755918Ab0FHWq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:46:57 -0400
Date: Wed, 9 Jun 2010 08:46:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V4
Message-ID: <20100608224615.GE7869@dastard>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
 <alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:41:28AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 8 Jun 2010, Dave Chinner wrote:
> >
> > Can you please consider this patch series for 2.6.35?
> 
> Yeah, no. See the several lkml discussions and the -rc2 announcement about 
> how I do _not_ intend to merge anything even remotely "new code" this time 
> around.
> 
> So purely regression fixes and serious bugfixes (oopses/security issues).

No worries,  I'll re-order the series and send you just the bug
fixes later this morning.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
