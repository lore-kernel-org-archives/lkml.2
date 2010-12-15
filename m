Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0LOQuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:50:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0LOQu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:50:29 -0500
Message-ID: <4D08F1A2.6040801@redhat.com>
Date: Wed, 15 Dec 2010 11:49:38 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
In-Reply-To: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 10:49 AM, Miklos Szeredi wrote:
> From: Miklos Szeredi<mszeredi@suse.cz>
>
> This function basically does:
>
>       remove_from_page_cache(old);
>       page_cache_release(old);
>       add_to_page_cache_locked(new);
>
> Except it does this atomically, so there's no possibility for the
> "add" to fail because of a race.
>
> This is used by fuse to move pages into the page cache.
>
> Signed-off-by: Miklos Szeredi<mszeredi@suse.cz>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
