Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab2INT2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:28:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62519 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759973Ab2INT2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:28:37 -0400
Message-ID: <50538561.8030505@suse.cz>
Date: Fri, 14 Sep 2012 21:28:33 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: BUG at mm/huge_memory.c:1428!
References: <50522275.7090709@suse.cz> <CANN689E0SaT9vaBb+snwYrP728GjZhRj7o7T4GoNfQVY7sBr7Q@mail.gmail.com>
In-Reply-To: <CANN689E0SaT9vaBb+snwYrP728GjZhRj7o7T4GoNfQVY7sBr7Q@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 12:46 AM, Michel Lespinasse wrote:
> On Thu, Sep 13, 2012 at 11:14 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> Hi,
>>
>> I've just get the following BUG with today's -next. It happens every
>> time I try to update packages.
>>
>> kernel BUG at mm/huge_memory.c:1428!
> 
> That is very likely my bug.
> 
> Do you have the message that should be printed right above the bug ?
> (                printk(KERN_ERR "mapcount %d page_mapcount %d\n",
>                        mapcount, page_mapcount(page));
> )

Unfortunately no. And I cannot reproduce anymore :(...

thanks,
-- 
js
suse labs
