Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2L2HZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 02:25:58 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:52422 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2L2HZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 02:25:57 -0500
MIME-Version: 1.0
In-Reply-To: <50DC6C6F.6050703@iskon.hr>
References: <50D24AF3.1050809@iskon.hr>
	<50D24CD9.8070507@iskon.hr>
	<CAJd=RBCQN1GxOUCwGPXL27d_q8hv50uHK5LhDnsv7mdv_2Usaw@mail.gmail.com>
	<50DC6C6F.6050703@iskon.hr>
Date: Sat, 29 Dec 2012 15:25:56 +0800
Message-ID: <CAJd=RBB0bwyjoMc5yt5SfgxCt3JcLUo8Fiz1r3oQ0RRhE1i59w@mail.gmail.com>
Subject: Re: [PATCH] mm: do not sleep in balance_pgdat if there's no i/o congestion
From: Hillf Danton <dhillf@gmail.com>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 11:42 PM, Zlatko Calusic
<zlatko.calusic@iskon.hr> wrote:
> On 21.12.2012 12:51, Hillf Danton wrote:
>>
>> On Thu, Dec 20, 2012 at 7:25 AM, Zlatko Calusic <zlatko.calusic@iskon.hr>
>> wrote:
>>>
>>>   static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>>>                                                          int
>>> *classzone_idx)
>>>   {
>>> -       int all_zones_ok;
>>> +       struct zone *unbalanced_zone;
>>
>>
>> nit: less hunks if not erase that mark
>>
>> Hillf
>
>
> This one left unanswered and forgotten because I didn't understand what you
> meant. Could you elaborate?
>
Sure, the patch looks simpler(and nicer) if we dont
erase all_zones_ok.

Hillf
