Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab0DAXhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:37:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57637 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab0DAXhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:37:12 -0400
Date: Thu, 1 Apr 2010 18:37:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, containers@lists.linux-foundation.org,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [C/R v20][PATCH 00/96] Linux Checkpoint-Restart - v20
Message-ID: <20100401233710.GA23711@us.ibm.com>
References: <1268842164-5590-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268842164-5590-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Hi Andrew,
> 
> Following up on the thread on the checkpoint-restart patch set
> (http://lkml.org/lkml/2010/3/1/422), the following series is the
> latest checkpoint/restart, based on 2.6.33.
> 
> The first 20 patches are cleanups and prepartion for c/r; they
> are followed by the actual c/r code.
> 
> Please apply to -mm, and let us know if there is any way we can
> help.

Hi Andrew,

Oren sent v20 of the checkpoint/restart patchset out two weeks ago.
We've addressed some feedback from linux-fsdevel and added network and
pid namespace support.  So we could resend again now.  However we also
have a bigger patchset in the works which is feature-neutral, but moves
all the code out of linux-2.6/checkpoint/ and next to the code it
affects.  I ancitipate #ifdef clashes though, so we'll
need to do quite a bit of various-config-and-arch testing of the new
code layout.  If you're at a good point to pull it, we can resend the
code as is now so as to get some wider testing exposure. Or, if you prefer,
we can wait until after the code move in case that would be seen as more
amenable to meaningful review.

We don't want to patch-bomb needlessly so thought we'd ask first :)

thanks,
-serge
