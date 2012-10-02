Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab2JBHEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:04:11 -0400
Received: from smtp.getmail.no ([84.208.15.66]:49346 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab2JBHEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:04:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: Mike Galbraith <efault@gmx.de>
Subject: Re: The 10ms averager in fair.c
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
 <op.wlh4u2xj6426ze@millennium.getinternet.no>
 <1349146202.7086.23.camel@marge.simpson.net>
Date: Tue, 02 Oct 2012 09:04:09 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wljhw7yc6426ze@localhost.localdomain>
In-reply-to: <1349146202.7086.23.camel@marge.simpson.net>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so you don`t know. Well, then it looks like what I said, to me. What  
is a 100us load, that gets filtered by a 10ms filter? Nothing.
Or a very very small value that rises and falls over 10ms.  
Load-distribution based on a spike that happened a long time ago (in  
computing terms) seems very odd. You don`t even know the average before  
5ms.

I am going to look at the code, and see if I can make a patch.

Peace Be With You.

On Tue, 02 Oct 2012 04:50:02 +0200, Mike Galbraith <efault@gmx.de> wrote:

> On Mon, 2012-10-01 at 15:24 +0200, Uwaysi Bin Kareem wrote:
>
>> Are you sure this isn`t just a design-philosophy that was done, without
>> much knowledge of filters?
>
> Are you?  I see "I don't see the point", along with "I haven't looked
> closely".  If you look, perhaps you'll see a better way, and can post
> patches.  That's the strength of opensource.
>
> -Mike
