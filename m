Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2IQPjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:39:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63809 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2IQPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:39:35 -0400
Message-ID: <50574432.5040005@suse.cz>
Date: Mon, 17 Sep 2012 17:39:30 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: BUG at mm/huge_memory.c:1428!
References: <50522275.7090709@suse.cz> <CANN689E0SaT9vaBb+snwYrP728GjZhRj7o7T4GoNfQVY7sBr7Q@mail.gmail.com> <50538561.8030505@suse.cz>
In-Reply-To: <50538561.8030505@suse.cz>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 09:28 PM, Jiri Slaby wrote:
> On 09/14/2012 12:46 AM, Michel Lespinasse wrote:
>> On Thu, Sep 13, 2012 at 11:14 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> Hi,
>>>
>>> I've just get the following BUG with today's -next. It happens every
>>> time I try to update packages.
>>>
>>> kernel BUG at mm/huge_memory.c:1428!
>>
>> That is very likely my bug.
>>
>> Do you have the message that should be printed right above the bug ?
>> (                printk(KERN_ERR "mapcount %d page_mapcount %d\n",
>>                        mapcount, page_mapcount(page));
>> )
> 
> Unfortunately no. And I cannot reproduce anymore :(...

FWIW: mapcount 0 page_mapcount 1

It happened today. Now I'm going to apply your patch.

> thanks,
-- 
js
suse labs
