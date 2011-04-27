Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1D0PAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:00:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36386 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab1D0PAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:00:43 -0400
Date: Wed, 27 Apr 2011 17:00:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, drosenberg@vsecurity.com,
        ak@linux.intel.com, eugeneteo@kernel.org, aelder@sgi.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [8/106] xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
Message-ID: <20110427150039.GP16484@one.firstfloor.org>
References: <20110426212.641772347@firstfloor.org> <20110426211246.2E1863E1887@tassilo.jf.intel.com> <20110427052610.GH12436@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427052610.GH12436@dastard>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > v2 switches to memset() to avoid future issues if structure members
> > change, on suggestion of Dave Chinner.
> 
> Did you grab the followup patch that fixed the stack corruption
> this change caused?

No. Which commit ID is that?

I don't see any obvious further changes to that file in mainline.

-Andi
