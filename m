Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab2LGLr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:47:59 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:34388 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2LGLr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:47:58 -0500
Message-ID: <50C1D758.1080007@cs.tu-berlin.de>
Date: Fri, 07 Dec 2012 12:47:36 +0100
From: =?ISO-8859-1?Q?=22Jan_H=2E_Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120324 Thunderbird/10.0.3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2 00/14] printk() fixes, optimizations, and clean ups
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>  <20121206133907.37c255e9.akpm@linux-foundation.org>  <1354837050.22463.4.camel@joe-AO722>  <20121206161943.78633125.akpm@linux-foundation.org> <1354848669.22463.23.camel@joe-AO722>
In-Reply-To: <1354848669.22463.23.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.12.2012 03:51, schrieb Joe Perches:
> On Thu, 2012-12-06 at 16:19 -0800, Andrew Morton wrote:
>> On Thu, 06 Dec 2012 15:37:30 -0800
>> Joe Perches <joe@perches.com> wrote:
>>> Can you please pick this up for -next now and I'll
>>> redo my patches against -next for -rc1 so I'm not
>>> delayed until 3.9?
>>
>> It would be better to do things in the other order.
>>
>> a) Your patches perform mainly code-movement which doesn't cause
>>    functional changes.  Jan's patches are functional changes which
>>    require more thought and testing and possible fixups.
> 
> Fine by me.  Jan?

No problem.

I agree with Andrew, that patches 9 to 14 could use indeed some
more eyeballs.

Patches 1 to 8 are more straight-forward, and I would consider
these ready. However, they are also those, where I probably won't
have any trouble rebasing them on top of your changes.


Anyway. Until now I always thought my patches will end up in the
queue of some maintainer, so that I don't have to bother about
_when_ posting my patches. Therefore: when should I repost a
version rebased on top of Joe's changes?

(If I'd get some opinions on 9 to 14 until then, all the better.)

Regards
Jan

