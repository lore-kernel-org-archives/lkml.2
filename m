Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1ATMdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:33:15 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37856 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1ATMdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:33:13 -0500
Message-ID: <4D382B99.7070005@vflare.org>
Date: Thu, 20 Jan 2011 07:33:29 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] zcache: page cache compression support
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org 20110110131626.GA18407@shutemov.name> <9e7aa896-ed1f-4d50-8227-3a922be39949@default>
In-Reply-To: <9e7aa896-ed1f-4d50-8227-3a922be39949@default>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 12:53 PM, Dan Magenheimer wrote:
>> From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
>> Sent: Monday, January 10, 2011 6:16 AM
>> To: Nitin Gupta
>> Cc: Pekka Enberg; Hugh Dickins; Andrew Morton; Greg KH; Dan
>> Magenheimer; Rik van Riel; Avi Kivity; Christoph Hellwig; Minchan Kim;
>> Konrad Rzeszutek Wilk; linux-mm; linux-kernel
>> Subject: Re: [PATCH 0/8] zcache: page cache compression support
>>
>> Hi,
>>
>> What is status of the patchset?
>> Do you have updated patchset with fixes?
>>
>> --
>>   Kirill A. Shutemov
> I wanted to give Nitin a week to respond, but I guess he
> continues to be offline.
>

Sorry, I was on post-exam-vacations, so couldn't
look into it much :)

> I believe zcache is completely superceded by kztmem.
> Kztmem, like zcache, is dependent on cleancache
> getting merged.
>
> Kztmem may supercede zram also although frontswap (which
> kztmem uses for a more dynamic in-memory swap compression)
> and zram have some functional differences that support
> both being merged.
>
> For latest kztmem patches and description, see:
>
> https://lkml.org/lkml/2011/1/18/170
>

I just started looking into kztmem (weird name!) but on
the high level it seems so much similar to zcache with some
dynamic resizing added (callback for shrinker interface).

Now, I'll try rebuilding zcache according to new cleancache
API as provided by these set of patches. This will help refresh
whatever issues I was having back then with pagecache
compression and maybe pick useful bits/directions from
new kztmem work.

(PAM etc. synonyms make kztmem code reading quite heavy, and
I still don't like frontswap approach but unfortunately do not yet
have any better alternatives ready yet).

Thanks,
Nitin

