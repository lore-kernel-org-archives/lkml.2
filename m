Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0G0TdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0G0TdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:33:14 -0400
Message-ID: <4C4F348C.3040703@redhat.com>
Date: Tue, 27 Jul 2010 16:33:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/15] STAGING: add lirc device drivers
References: <20100726232546.GA21225@redhat.com> <4C4F0244.2070803@redhat.com> <20100727160955.GA7528@kroah.com> <20100727182404.GE9465@redhat.com>
In-Reply-To: <20100727182404.GE9465@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-07-2010 15:24, Jarod Wilson escreveu:
> On Tue, Jul 27, 2010 at 09:09:56AM -0700, Greg KH wrote:
>> On Tue, Jul 27, 2010 at 12:59:00PM -0300, Mauro Carvalho Chehab wrote:
>>> Em 26-07-2010 20:25, Jarod Wilson escreveu:
>>
>> Hm, Jarod, you forgot to cc: the staging maintainer, so I missed these
>> :)
> 
> D'oh, sorry, yeah, realized that about 10 minutes after I sent everything.
> Figured I'd ping you if you hadn't said anything about 'em in a day or
> three.
> 
>>> Greg,
>>>
>>> It is probably simpler to merge those files via my tree, as they depend
>>> on some changes scheduled for 2.6.36.
>>>
>>> Would it be ok for you if I merge them from my tree?
>>
>> No objection from me for them to go through your tree.

Ok, thanks. I'll merge the patches on my tree.

>>
>> Do you want me to handle the cleanup and other fixes after they go into
>> the tree, or do you want to also handle them as well (either is fine
>> with me.)
> 
> Note that I've got a git tree I've been maintaining the lirc drivers in
> for a while, so whomever is ultimately the gateway, I can also stage
> cleanups there -- I'll certainly be pushing any cleanups I do on the lirc
> drivers there prior to sending along for upstream, or else I'm liable to
> lose track of them... :)
> 
> http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-lirc.git
> 

Well, maybe the easiest way would be if I handle the first merge, to be sure that
they'll reach linux-next and 2.6.36 at the right time, avoiding conflicts with some
core changes. After the merge, Jerod can handle it via his own tree.

Cheers,
Mauro
