Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0FDKvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:51:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47637 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707Ab0FDKvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:51:18 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: mmotm 2010-06-03-16-36 lots of suspected kmemleak
References: <AANLkTilb4QNYznFeJVfMmvPAlBY-B02EY0i0d7NK9X7O@mail.gmail.com>
Date: Fri, 04 Jun 2010 11:50:34 +0100
In-Reply-To: <AANLkTilb4QNYznFeJVfMmvPAlBY-B02EY0i0d7NK9X7O@mail.gmail.com>
	(Dave Young's message of "Fri, 4 Jun 2010 16:27:54 +0800")
Message-ID: <tnxvd9zcbr9.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jun 2010 10:50:39.0344 (UTC) FILETIME=[C54EA700:01CB03D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young <hidave.darkstar@gmail.com> wrote:
> With mmotm 2010-06-03-16-36, I gots tuns of kmemleaks

Do you have CONFIG_NO_BOOTMEM enabled? I posted a patch for this but
hasn't been reviewed yet (I'll probably need to repost, so if it fixes
the problem for you a Tested-by would be nice):

http://lkml.org/lkml/2010/5/4/175

Thanks.

-- 
Catalin
