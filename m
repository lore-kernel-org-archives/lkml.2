Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0HTDq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 23:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab0HTDqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 23:46:25 -0400
Message-ID: <4C6DFA78.10800@redhat.com>
Date: Thu, 19 Aug 2010 23:46:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, david@fromorbit.com,
        hch@lst.de, axboe@kernel.dk, Michael Rubin <mrubin@google.com>,
        Jan Kara <jack@suse.cz>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] writeback: remove the internal 5% low bound on dirty_ratio
References: <20100820032506.GA6662@localhost>
In-Reply-To: <20100820032506.GA6662@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 11:25 PM, Wu Fengguang wrote:
> The dirty_ratio was silently limited to>= 5%. This is not a user
> expected behavior. Let's rip it.
>
> It's not likely the user space will depend on the old behavior.
> So the risk of breaking user space is very low.
>
> CC: Jan Kara<jack@suse.cz>
> CC: Neil Brown<neilb@suse.de>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
