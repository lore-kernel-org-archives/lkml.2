Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0GRJDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:03:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51694 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753303Ab0GRJDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:03:35 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+JQdg0k72JASqdk12cESF9Qua/7HjYMQ+b+hzkgU
	D5epJy1k+GyPJ0
Date: Sun, 18 Jul 2010 12:10:09 +0300 (EEST)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@localhost.localdomain
To: "Ted Ts'o" <tytso@mit.edu>
cc: Randy Dunlap <rdunlap@xenotime.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        linux-kernel@vger.kernel.org, Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
In-Reply-To: <20100718071552.GB4684@thunk.org>
Message-ID: <alpine.LNX.2.00.1007181149560.3666@localhost.localdomain>
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain> <m3tyny31mo.fsf@intrepid.localdomain> <20100717065146.732f5449.rdunlap@xenotime.net> <20100718071552.GB4684@thunk.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jul 2010, Ted Ts'o wrote:
> On Sat, Jul 17, 2010 at 06:51:46AM -0700, Randy Dunlap wrote:
>> On Sat, 17 Jul 2010 11:21:03 +0200 Krzysztof Halasa wrote:
>>
>>> Dimitrios Apostolou <jimis@gmx.net> writes:
>>>
>>>> static void update_group_shares_cpu(struct task_group *tg, int cpu,
>>>>                                     unsigned long sd_shares,
>>>>                                     unsigned long sd_rq_weight,
>>>>                                     unsigned long *usd_rq_weight)
>>>> {
>>>
>>> From a technical POV the above should not have any tabs, the parameters
>>> should be aligned with spaces only.
>>
>> fwiw, it seems that you agree with Ted.
>
> Actually, what my code use is tabs with a tab stop of 8 followed by
> enough spaces (< 7) to align function parameters and to align
> open/close parenthesis in C expression line wrap.

FWIW that way will show the parameters unaligned to anyone using a 
different tab length. There is one way to align such lines properly:

You indent with as many tabs as the previous line has and you use all 
spaces (perhaps more than 8) afterwards, to align parameters where you 
want them. In the example above that would use 0 tabs, all spaces...

Unfortunately this style is not the default to any editor I have seen, 
even though it really makes code readable with any tab length. Even for 
emacs you have to customize your config file:
http://www.emacswiki.org/emacs/SmartTabs


Dimitris

