Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0HCHBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:01:04 -0400
Received: from tuxonice.net ([74.207.252.127]:44591 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab0HCHBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:01:02 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C57BEA9.9020504@tuxonice.net>
Date: Tue, 03 Aug 2010 17:00:57 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: Nigel's current for-rafael queue
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net> <20100803065543.GF3344@ucw.cz>
In-Reply-To: <20100803065543.GF3344@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 03/08/10 16:55, Pavel Machek wrote:
> On Wed 2010-06-02 22:18:59, Nigel Cunningham wrote:
>> Hi all.
>>
>> Here is my current patch queue.
>>
>> Taken together, the patches implement the separation of low level
>> block i/o into a separate file, switch from using swap_map_pages
>> to extents stores prior to the 'header' page and implement fully
>> asynchronous (rather than batched I/O). I have only run it under
>> VMware so far, but would estimate a doubling in speed due to the
>> async i/o.
>
> Do you have any numbers from real hw? Could similar speedup be
> accomplished by just increasing the batch size?

Yeah. I've been thinking I should really prepend a patch that lets you 
get the stats post-resume - unless you guys have some trick to enable 
you to read them that I haven't noticed yet :)

Nigel
