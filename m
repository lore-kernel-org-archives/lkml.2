Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab2JKWmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:42:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:17025 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab2JKWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:42:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="233756082"
From: Andi Kleen <andi@firstfloor.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
Date: Thu, 11 Oct 2012 15:42:38 -0700
In-Reply-To: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	(Ezequiel Garcia's message of "Thu, 11 Oct 2012 11:19:30 -0300")
Message-ID: <m27gqwtyu9.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ezequiel Garcia <elezegarcia@gmail.com> writes:

> Hello,
>
> While I've always thought SLUB was the default and recommended allocator,
> I'm surprise to find that it's not always the case:

iirc the main performance reasons for slab over slub have mostly
disappeared, so in theory slab could be finally deprecated now.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
