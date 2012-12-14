Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2LNSnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:43:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61584 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab2LNSng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:43:36 -0500
MIME-Version: 1.0
In-Reply-To: <87r4ms5wpm.fsf@xmission.com>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
 <20121214032820.GA5115@mail.hallyn.com> <87bodxi9zw.fsf@xmission.com>
 <20121214152607.GA9266@mail.hallyn.com> <87bodwd4aw.fsf@xmission.com>
 <20121214161514.GA9962@mail.hallyn.com> <87r4ms5wpm.fsf@xmission.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Dec 2012 10:43:15 -0800
X-Google-Sender-Auth: eRmxPDoB4XK85vw3IYRn52diNa4
Message-ID: <CA+55aFw5CMf0-o=yDt2Rj-SYH4pfW1L9QbNb6uKHEdzAyYcvGQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent
 user namespace to have caps.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 10:12 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> That said Serge I think I have lost track of the point of your question.

.. and I'm a bit unsure what I should do about this all. Including
pulling the pull request that actually can make this all matter.

Hmm? Any consensus?

            Linus
