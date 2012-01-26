Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2AZX3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:29:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2AZX3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:29:00 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwS0=yb1Nwq=ph6-B5XRY-r7h+EjXq9EDDH7oj8UObrQw@mail.gmail.com>
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com>
 <4EC52FBF.1010407@parallels.com> <20111118233055.GA29378@google.com>
 <4ECA1696.5060500@parallels.com> <20111121225019.GQ25776@google.com>
 <4ECB8346.8040806@parallels.com> <20111122152312.GB322@google.com>
 <4ECBCE30.30001@parallels.com> <CA+55aFwS0=yb1Nwq=ph6-B5XRY-r7h+EjXq9EDDH7oj8UObrQw@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 27 Jan 2012 00:28:39 +0100
Message-ID: <CAPXgP12_EafamdpPwxFWY9GiTEE_qEY7wOWCn1MRZgNTF6ikbA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given pids
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 17:44, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
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
> this fox Xyz", is a *misfeature* in my opinion.  Core infrastructure
> like systemd should use a *minimal* interface, not some random
> extended features.

No worries, there is no plan from the systemd maintainers side to use
or need predictable PIDs. We still start, stop and restart service the
old-school way, and will leave checkpoint/restart to somebody else. :)

Kay
