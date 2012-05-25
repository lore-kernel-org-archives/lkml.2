Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2EYW1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:27:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:4928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab2EYW1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:27:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104447984"
From: Andi Kleen <andi@firstfloor.org>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: native_save_fl taking good amount of time in profile
References: <CALKntY1wDFxzZX6ONgeVuNjBxi=bPA-0vhWJ-_NMXR37GNmvBQ@mail.gmail.com>
Date: Fri, 25 May 2012 15:27:47 -0700
In-Reply-To: <CALKntY1wDFxzZX6ONgeVuNjBxi=bPA-0vhWJ-_NMXR37GNmvBQ@mail.gmail.com>
	(Xin Tong's message of "Fri, 25 May 2012 18:12:10 -0400")
Message-ID: <m2vcjjlwv0.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xin Tong <xerox.time.tech@gmail.com> writes:

> I have collected a profile on the whole system. But the only thing
> that is really running is a mysql database server. I have noticed that
> there is a function in kernel that took 5% of the overall running
> time. what does native_save_fl do ? does it make sense that
> native_save_fl takes the most amount of time among all kernel
> functions ?

What are the callers (-g)? It does not make sense normally.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
