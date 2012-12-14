Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2LNSrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:47:36 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34719 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab2LNSre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:47:34 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw5CMf0-o=yDt2Rj-SYH4pfW1L9QbNb6uKHEdzAyYcvGQ@mail.gmail.com>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
 <20121214032820.GA5115@mail.hallyn.com> <87bodxi9zw.fsf@xmission.com>
 <20121214152607.GA9266@mail.hallyn.com> <87bodwd4aw.fsf@xmission.com>
 <20121214161514.GA9962@mail.hallyn.com> <87r4ms5wpm.fsf@xmission.com> <CA+55aFw5CMf0-o=yDt2Rj-SYH4pfW1L9QbNb6uKHEdzAyYcvGQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Dec 2012 10:47:13 -0800
Message-ID: <CALCETrVzkDi2tUZV6qtXrFtD+dDtkrR5dVL_Sij=9DVEqsOWmg@mail.gmail.com>
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent
 user namespace to have caps.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 10:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Dec 14, 2012 at 10:12 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> That said Serge I think I have lost track of the point of your question.
>
> .. and I'm a bit unsure what I should do about this all. Including
> pulling the pull request that actually can make this all matter.
>
> Hmm? Any consensus?

I think that, if Eric submits a newer version that renames the loop
variable for added comprehensibility, I'm okay with it.

Changing the semantics to a more expansive version like Serge was
talking about later on wouldn't break anything.  But I don't think
there's any reason to change it.

--Andy
