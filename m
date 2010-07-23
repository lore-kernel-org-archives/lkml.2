Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab0GWQJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:09:33 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1366 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757748Ab0GWQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:09:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPFYSUx5Lc6U/2dsb2JhbACfaHLCAYU2BA
Date: Sat, 24 Jul 2010 02:09:25 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, fmayhar@google.com,
        johnstul@us.ibm.com
Subject: Re: [PATCH 0/2] vfs scalability tree fixes
Message-ID: <20100723160925.GA6316@amd>
References: <20100723111310.GI32635@dastard>
 <1279893842-4246-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279893842-4246-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 12:04:00AM +1000, Dave Chinner wrote:
> Nick,
> 
> Here's the fixes I applied to your tree to make the XFS inode cache
> shrinker build and scan sanely.

Thanks for these Dave
