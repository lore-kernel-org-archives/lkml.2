Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab0JFBVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:21:33 -0400
Received: from tuxonice.net ([74.207.252.127]:42435 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0JFBVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:21:32 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CABCF19.60902@tuxonice.net>
Date: Wed, 06 Oct 2010 12:21:29 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [PATCH 08/23] Hibernation: Generic extents support.
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <1285566238-10966-9-git-send-email-nigel@tuxonice.net> <20101004175122.GB1518@ucw.cz>
In-Reply-To: <20101004175122.GB1518@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 05/10/10 04:51, Pavel Machek wrote:
> Hi!
>
>> Separate out the extent storage and manipulation into a separate
>> file and make them more generic, so we can also use extents for
>> recording what sectors are used and (later) support multiple
>> storage devices more easily.
>>
>> Signed-off-by: Nigel Cunningham<nigel@tuxonice.net>
>
>> @@ -0,0 +1,125 @@
>> +/*
>> + * linux/kernel/power/extents.c
>> + *
>> + * This file provides functions for storing and using a series of
>> + * extents.
>> + *
>> + * Copyright (C) 1998,2001-2005 Pavel Machek<pavel@suse.cz>
>
> That address is no longer valid :-(. Jiri Kosina should already have
> patches to remove it elsewhere in the tree.

Okay. You want ucw.cz or something else?

>> +/**
>> + *	free_all_swap_pages - free swap pages allocated for saving image data.
>> + *	It also frees the extents used to register which swap entres had been
>> + *	allocated.
>> + */
>> +
>> +void hib_extents_clear(struct hib_extent_state *pos)
>
> Comment does not match function.

Thanks.

Nigel
