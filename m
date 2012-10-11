Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2JKXLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:11:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:39036 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab2JKXLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:11:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="204561833"
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	<m27gqwtyu9.fsf@firstfloor.org>
	<alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
Date: Thu, 11 Oct 2012 16:10:40 -0700
In-Reply-To: <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
	(David Rientjes's message of "Thu, 11 Oct 2012 15:59:19 -0700 (PDT)")
Message-ID: <m2391ktxjj.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> On Thu, 11 Oct 2012, Andi Kleen wrote:
>
>> > While I've always thought SLUB was the default and recommended allocator,
>> > I'm surprise to find that it's not always the case:
>> 
>> iirc the main performance reasons for slab over slub have mostly
>> disappeared, so in theory slab could be finally deprecated now.
>> 
>
> SLUB is a non-starter for us and incurs a >10% performance degradation in 
> netperf TCP_RR.

When did you last test? Our regressions had disappeared a few kernels
ago.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
