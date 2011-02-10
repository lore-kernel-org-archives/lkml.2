Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1BJEoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:44:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64131 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1BJEoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AmAoKkH84cLVyBnduByRYaiu8FISrxCv5TdRFgl4TAVYiuJH3OplxtBvBNr4cvfaj1
         5XMYXIf77PkyZUaZ/v5QPzUvowYHE0Xe+jkd1mT7u7zur5BAxmzcvl3cTCTa9tljmF+a
         UTpp5wdBrXjzeP2SX8gB0xdxO/5QrlDnDb1pc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikdBhSWAoP6TDRExSV2rHmWDkEc0foSKvqJt=tx@mail.gmail.com>
References: <1297262537-7425-1-git-send-email-ozaki.ryota@gmail.com>
	<20110210085823.2f99b81c.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikdBhSWAoP6TDRExSV2rHmWDkEc0foSKvqJt=tx@mail.gmail.com>
Date: Thu, 10 Feb 2011 13:44:09 +0900
Message-ID: <AANLkTik36rhvou2Bu99LMkAXx+BYQJysPxZG1gAAJwyv@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix out-of-date comments which refers non-existent functions
From: Minchan Kim <minchan.kim@gmail.com>
To: Ryota Ozaki <ozaki.ryota@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 12:58 PM, Ryota Ozaki <ozaki.ryota@gmail.com> wrote:
> On Thu, Feb 10, 2011 at 8:58 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Wed,  9 Feb 2011 23:42:17 +0900
>> Ryota Ozaki <ozaki.ryota@gmail.com> wrote:
>>
>>> From: Ryota Ozaki <ozaki.ryota@gmail.com>
>>>
>>> do_file_page and do_no_page don't exist anymore, but some comments
>>> still refers them. The patch fixes them by replacing them with
>>> existing ones.
>>>
>>> Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
>>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Thanks, Kamezawa-san.
>
>>
>> It seems there are other ones ;)
>> ==
>>    Searched full:do_no_page (Results 1 - 3 of 3) sorted by relevancy
>>
>>  /linux-2.6-git/arch/alpha/include/asm/
>> H A D   cacheflush.h    66 /* This is used only in do_no_page and do_swap_page. */
>>  /linux-2.6-git/arch/avr32/mm/
>> H A D   cache.c         116 * This one is called from do_no_page(), do_swap_page() and install_page().
>>  /linux-2.6-git/mm/
>> H A D   memory.c        2121 * and do_anonymous_page and do_no_page can safely check later on).
>> 2319 * do_no_page is protected similarly.
>
> Nice catch :-) Cloud I assemble all fixes into one patch?
>
>  ozaki-r
>

When you resend the patch, Please Cc Jiri Kosina <trivial@kernel.org>


-- 
Kind regards,
Minchan Kim
