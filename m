Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0JOIuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:50:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47362 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0JOIuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:50:15 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        akpm@linux-foundation.org
Subject: Re: RFC: Implement hwpoison on free for soft offlining
References: <1286402951-1881-1-git-send-email-andi@firstfloor.org>
Date: Fri, 15 Oct 2010 10:50:13 +0200
In-Reply-To: <1286402951-1881-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Thu, 7 Oct 2010 00:09:10 +0200")
Message-ID: <874ocnc01m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Here's a somewhat experimental patch to improve soft offlining
> in hwpoison, but allowing hwpoison on free for not directly
> freeable page types. It should work for nearly all
> left over page types that get eventually freed, so this makes
> soft offlining nearly universal. The only non handleable page
> types are now pages that never get freed.
>
> Drawback: It needs an additional page flag. Cannot set hwpoison
> directly because that would not be "soft" and cause errors.
>
> Since the flags are scarce on 32bit I only enabled it on 64bit.
>
> Comments?

I got a couple of positive comments and reviews and no negative comments.

So I assume noone has a problem with using up a 64bit page flag
for this. I plan to push this into linux-next after some delay
and then prepare it for merge later.

If there are any objections please speak up now.

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
