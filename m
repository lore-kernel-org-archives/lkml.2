Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447Ab0COQw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:52:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44353 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965390Ab0COQw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:52:56 -0400
Message-ID: <4B9E65DE.7060409@cs.helsinki.fi>
Date: Mon, 15 Mar 2010 18:52:46 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Lars Lindley <lindley@coyote.org>,
       gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       diegoliz@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de
Subject: Re: [PATCH] staging: winbond: mds.c whitspace, indentation etc.
References: <1268670973-6223-1-git-send-email-lindley@coyote.org> <20100315165052.GA2661@bicker>
In-Reply-To: <20100315165052.GA2661@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> On Mon, Mar 15, 2010 at 05:36:13PM +0100, Lars Lindley wrote:
>> I fixed most of the problems found by checkpatch.pl.
>> Some long lines are left and some KERN_..
>> This is a new revised patch against master with changes
>> after comments from Stefan Richter and Dan Carpenter.
>> Forget the old one.
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>> Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> Acked-by: Dan Carpenter <error27@gmail.com>

It's pretty difficult to say if anything changed based on the diff so 
would you mind posting before and after output of 'size mds.o', please?
