Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2IZLXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:23:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62316 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2IZLXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:23:35 -0400
Date: Wed, 26 Sep 2012 13:23:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] UV: fix incorrect tlb flush all issue
Message-ID: <20120926112330.GC21143@gmail.com>
References: <E1TGULk-000162-7Y@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1TGULk-000162-7Y@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> (this was sent as an ack on 9/13, but with incorrect title and sign-off)
> 
> Ack.
> But with the adjustment below.  The 'end' argument was not declared long.
> 
> I tested the patch on a UV.
> It has the effect of either clearing 1 or all TLBs in a cpu.
> I added some debugging to test for the cases when clearing all TLBs is
> overkill, and in practice it happens very seldom.
> 
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Cliff Wickman <cpw@sgi.com>

If this is still substantially the original patch then I suspect 
this should be From: Alex Shi, and the small fix you made can be 
added as:

 Signed-off-by: Alex Shi <alex.shi@intel.com>
 [ fixed the 'end' argument to be declared 'long'. ]
 Signed-off-by: Cliff Wickman <cpw@sgi.com>

Thanks,

	Ingo
