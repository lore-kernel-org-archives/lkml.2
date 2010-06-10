Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab0FJSKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:10:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40531 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab0FJSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:10:14 -0400
Date: Thu, 10 Jun 2010 20:10:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/23] x86: percpu: Avoid warnings of unused variables
	in per cpu
Message-ID: <20100610181007.GH19561@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111036.DAE8EB1A2C@basil.firstfloor.org> <4C10C930.9080900@kernel.org> <20100610120951.GC16514@elte.hu> <4C112452.60200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C112452.60200@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for this.. I applied it over
> here.. and now don't have all of
> that spam from percpu while compiling
> the kernel..

Which gcc version are you using?
>
> only one I see now is something about
> warning: variable 'gfp' set but not used

That's fixed in 'IRQ: Move alloc_desk_mask variables inside ifdef'

The whole series fixes a lot more warnings, however
there are still quite some left (in my config)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
