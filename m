Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0FSIRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:17:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34709 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab0FSIRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:17:02 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org,
       david@fromorbit.com, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 3/3] writeback: tracking subsystems causing writeback
References: <1276907415-504-1-git-send-email-mrubin@google.com>
	<1276907415-504-4-git-send-email-mrubin@google.com>
Date: Sat, 19 Jun 2010 10:17:01 +0200
In-Reply-To: <1276907415-504-4-git-send-email-mrubin@google.com> (Michael
	Rubin's message of "Fri, 18 Jun 2010 17:30:15 -0700")
Message-ID: <878w6bphc2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Rubin <mrubin@google.com> writes:
>
>     # cat /sys/block/sda/bdi/writeback_stats
>     balance dirty pages                       0
>     balance dirty pages waiting               0
>     periodic writeback                    92024
>     periodic writeback exited                 0
>     laptop periodic                           0
>     laptop or bg threshold                    0
>     free more memory                          0
>     try to free pages                       271
>     syc_sync                                  6
>     sync filesystem                           0

That exports a lot of kernel internals in /sys, presumably read by some
applications. What happens with the applications if the kernel internals
ever change?  Will the application break?

It would be bad to not be able to change the kernel because of
such an interface.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
