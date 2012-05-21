Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2EUW5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:57:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:50068 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab2EUW5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:57:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145955250"
From: Andi Kleen <andi@firstfloor.org>
To: Joe Korty <joe.korty@ccur.com>
Cc: stasn77@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] port jRCU from 3.3 to 3.4
References: <20120521184528.GA4145@tsunami.ccur.com>
Date: Mon, 21 May 2012 15:57:44 -0700
In-Reply-To: <20120521184528.GA4145@tsunami.ccur.com> (Joe Korty's message of
	"Mon, 21 May 2012 14:45:28 -0400")
Message-ID: <m2vcjp87mf.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty <joe.korty@ccur.com> writes:
> + *
> + * jRCU assumes that the frames are large enough that architecture barrier
> + * operations performed in one frame have fully completed by the start of
> + * the next.  This period is presumed to be in the tens of microseconds, so
> + * it may not be wise to run jRCU at a frame rate under 100 usecs.

This sounds like a very dangerous assumption.

-Andi

