Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab0FEI2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 04:28:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47280 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab0FEI2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 04:28:53 -0400
Message-ID: <4C0A0AB6.20206@cs.helsinki.fi>
Date: Sat, 05 Jun 2010 11:28:38 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Minchan Kim <minchan.kim@gmail.com>, Nitin Gupta <ngupta@vflare.org>,
       Greg KH <greg@kroah.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Support generic I/O requests
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>	<1275379286-10453-2-git-send-email-ngupta@vflare.org>	<AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com> <20100604121957.d9bc55ae.akpm@linux-foundation.org>
In-Reply-To: <20100604121957.d9bc55ae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> I thought zram is related to memory management a little bit.
>>
>> What's the criteria?
> 
> Yes, and this is something which bothers me a bit about the -staging
> process.  Code gets in there largely under the radar of the people who
> work in that area.  It gets "matured" for a while and the developer
> thinks it's all ready to go into "mainline" and ....  then what? 
> Someone needs to yank the code out of -staging and tell the interested
> parties "hey, look at this".  And at this stage, they might say "hell
> no", or request large changes and the developer who thought everything
> was all ready to go would be justifiably upset.

Yeah, that's what I assumed would happen here. When the code in -staging 
is "good enough", Nitin would submit squashed patches for inclusion 
review and when everyone is happy, we'd merge the code including full 
history from -staging.

Btw, ramzswap and zram have been discussed openly on LKML. I guess Nitin 
should have CC'd linux-mm as well for you to see it Andrew?

			Pekka
