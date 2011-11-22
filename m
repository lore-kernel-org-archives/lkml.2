Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab1KVQoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:44:44 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53759 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1KVQon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:44:43 -0500
MIME-Version: 1.0
In-Reply-To: <4ECBCE30.30001@parallels.com>
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com>
 <4EC52FBF.1010407@parallels.com> <20111118233055.GA29378@google.com>
 <4ECA1696.5060500@parallels.com> <20111121225019.GQ25776@google.com>
 <4ECB8346.8040806@parallels.com> <20111122152312.GB322@google.com> <4ECBCE30.30001@parallels.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Nov 2011 08:44:21 -0800
X-Google-Sender-Auth: J8iLQYvcZ60SBSzHDy7MOv0NaWo
Message-ID: <CA+55aFwS0=yb1Nwq=ph6-B5XRY-r7h+EjXq9EDDH7oj8UObrQw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given pids
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 8:30 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>>>
>>> I think that systemd guys can play with it. E.g. respawning daemons with predefined
>>> pids sounds like an interesting thing to play with.
>>
>> But wouldn't CAP_CHECKPOINT be enough for systemd?
>
> It would, but what's the point in granting to a systemd (which can be a container's
> init by the way) the ability to use the _whole_ checkpoint/restore engine?

Christ, stop making it sound like we would *want* systemd to do even
more odd things.

Quite frankly, any feature that is sold with ".. and systemd can use
this fox Xyz", is a *misfeature* in my opinion.  Core infrastructure
like systemd should use a *minimal* interface, not some random
extended features.

I'm starting to really dislike this whole feature discussion.

                Linus
