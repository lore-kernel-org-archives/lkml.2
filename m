Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965559Ab0CORVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:21:47 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:56179 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965540Ab0CORVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:21:44 -0400
X-SENDER-IP: [83.226.250.22]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiFBAA4KnktT4voWPGdsb2JhbACBPYQtgXeTGwEBAQE3ui+EewQ
X-IronPort-AV: E=Sophos;i="4.49,644,1262559600"; 
   d="scan'208";a="50625127"
Message-ID: <4B9E6CA2.10602@coyote.org>
Date: Mon, 15 Mar 2010 18:21:38 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Dan Carpenter <error27@gmail.com>, gregkh@suse.de, greg@kroah.com,
       pavel@ucw.cz, diegoliz@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de
Subject: Re: [PATCH] staging: winbond: mds.c whitspace, indentation etc.
References: <1268670973-6223-1-git-send-email-lindley@coyote.org> <20100315165052.GA2661@bicker> <4B9E65DE.7060409@cs.helsinki.fi>
In-Reply-To: <4B9E65DE.7060409@cs.helsinki.fi>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-15 17:52, Pekka Enberg wrote:
> Dan Carpenter wrote:
>> On Mon, Mar 15, 2010 at 05:36:13PM +0100, Lars Lindley wrote:
>>> I fixed most of the problems found by checkpatch.pl.
>>> Some long lines are left and some KERN_..
>>> This is a new revised patch against master with changes
>>> after comments from Stefan Richter and Dan Carpenter.
>>> Forget the old one.
>>>
>>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>>> Acked-by: Pavel Machek <pavel@ucw.cz>
>>
>> Acked-by: Dan Carpenter <error27@gmail.com>
> 
> It's pretty difficult to say if anything changed based on the diff so
> would you mind posting before and after output of 'size mds.o', please?
> 
Hi Pekka.

Before:
lali@lazer2 ~/linux3/linux-2.6 $ size drivers/staging/winbond/mds.o
   text	   data	    bss	    dec	    hex	filename
   2804	      0	      0	   2804	    af4	drivers/staging/winbond/mds.o

After:
lali@lazer2 ~/linux2/linux-2.6 $ size drivers/staging/winbond/mds.o
   text	   data	    bss	    dec	    hex	filename
   2804	      0	      0	   2804	    af4	drivers/staging/winbond/mds.o

diff:
lali@lazer2 ~/linux2/linux-2.6 $ diff ../../linux3/linux-2.6/drivers/staging/winbond/mds.o drivers/staging/winbond/mds.o
lali@lazer2 ~/linux2/linux-2.6 $ 

linux3 is a clean tree and linux2 the one i'm working on..

Regards
/Lars
