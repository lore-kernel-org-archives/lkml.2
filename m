Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BORpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:45:23 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48636 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2BORpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:45:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6620"; a="161120767"
Date: Wed, 15 Feb 2012 11:45:16 -0600
From: Richard Kuo <rkuo@codeaurora.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: hexagon: signal handling bugs
Message-ID: <20120215174516.GC29780@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org>
 <20110817163521.165013232@codeaurora.org>
 <20120211232740.GM23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120211232740.GM23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 11:27:40PM +0000, Al Viro wrote:
> I don't have any access to hardware *or* cross-toolchain, so all I can do
> here is RTFS and review.  For #2..#5 I would not be afraid to post untested
> patches (they are essentially trivial), but #1 is well beyond my arrogance
> threshold - messing in assembler glue on an architecture I don't know *and*
> can't test...  Sorry.

Thanks for reviewing the code.  Admittedly, it's been a while since I looked
at the signal handling bits, so I will need to review it again and test the
changes where appropriate.  I'll post a patch or something for review when
ready...



Thanks again,
Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
