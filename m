Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab0HQQRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:17:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48359 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab0HQQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K4Y7OmOl6povoJG9PmPP0Map80GH8cgkrgabzUaOwzGt+P/IA5G7dmec0f+BJXOLh2
         w80gMlgtYxsP4B/DK/mthkczlaokvl18M+oCa6Z8te1jaXyqoaswXpm3oTb3NS7Lpr1b
         d06nGHrqXJv246EKlOKIGffkbAvMhrJ+Ub9RM=
Date: Tue, 17 Aug 2010 20:17:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100817161715.GD5879@lenovo>
References: <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100817152225.GQ26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817152225.GQ26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 05:22:25PM +0200, Robert Richter wrote:
> Peter,
> 
> this is version 3 without timestamp code. Compared to -v1 it
> implements the handling for 2-1-0 nmi sequences.
> 
> -Robert
> 
> From 71a206394d8a3536b033247ec14ad037fef77236 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Tue, 17 Aug 2010 16:42:03 +0200
> Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
> 
... 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
...

Looks good to me, thanks a lot Robert!

	-- Cyrill
