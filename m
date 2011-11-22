Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1KVT3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:29:54 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:7002 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1KVT3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:29:52 -0500
Message-ID: <4ECBF829.4070202@parallels.com>
Date: Tue, 22 Nov 2011 23:29:45 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given
 pids
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com> <4EC52FBF.1010407@parallels.com> <20111118233055.GA29378@google.com> <4ECA1696.5060500@parallels.com> <20111121225019.GQ25776@google.com> <4ECB8346.8040806@parallels.com> <20111122152312.GB322@google.com> <4ECBCE30.30001@parallels.com> <CA+55aFwS0=yb1Nwq=ph6-B5XRY-r7h+EjXq9EDDH7oj8UObrQw@mail.gmail.com>
In-Reply-To: <CA+55aFwS0=yb1Nwq=ph6-B5XRY-r7h+EjXq9EDDH7oj8UObrQw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 08:44 PM, Linus Torvalds wrote:
> On Tue, Nov 22, 2011 at 8:30 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>>>>
>>>> I think that systemd guys can play with it. E.g. respawning daemons with predefined
>>>> pids sounds like an interesting thing to play with.
>>>
>>> But wouldn't CAP_CHECKPOINT be enough for systemd?
>>
>> It would, but what's the point in granting to a systemd (which can be a container's
>> init by the way) the ability to use the _whole_ checkpoint/restore engine?
> 
> Christ, stop making it sound like we would *want* systemd to do even
> more odd things.
> 
> Quite frankly, any feature that is sold with ".. and systemd can use
> this fox Xyz", is a *misfeature* in my opinion.  Core infrastructure
> like systemd should use a *minimal* interface, not some random
> extended features.

Damn, surely it should use a minimal! But our opinion doesn't prevent this daemon
from doing very weird stuff, and (believe it or not) I'm not trying to sell this
feature for systemd. Just trying to minimize the impact from systemd's use of it :(

> I'm starting to really dislike this whole feature discussion.
> 
>                 Linus
> .
> 

Thanks,
Pavel
