Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2LNUpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:45:13 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:41000 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2LNUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:45:10 -0500
Date: Fri, 14 Dec 2012 20:50:20 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the
 parent user namespace to have caps.
Message-ID: <20121214205020.GA11637@mail.hallyn.com>
References: <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com>
 <87zk1hshk7.fsf_-_@xmission.com>
 <20121214032820.GA5115@mail.hallyn.com>
 <87bodxi9zw.fsf@xmission.com>
 <20121214152607.GA9266@mail.hallyn.com>
 <87bodwd4aw.fsf@xmission.com>
 <20121214161514.GA9962@mail.hallyn.com>
 <87r4ms5wpm.fsf@xmission.com>
 <CA+55aFw5CMf0-o=yDt2Rj-SYH4pfW1L9QbNb6uKHEdzAyYcvGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw5CMf0-o=yDt2Rj-SYH4pfW1L9QbNb6uKHEdzAyYcvGQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> On Fri, Dec 14, 2012 at 10:12 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> >
> > That said Serge I think I have lost track of the point of your question.
> 
> .. and I'm a bit unsure what I should do about this all. Including
> pulling the pull request that actually can make this all matter.

Sorry I didn't mean to complicate this.

I did ack the patch and we can cull the cc list for continued discussion.

In practical terms, the only thing the patch prevent is having two
separate tasks each clone a new user ns with the same uid mapping, and
having consistent relationships between the same uids between the
namespaces.  It's worth it to prevent (or while we consider) the case
Andy and Eric bring up.

> Hmm? Any consensus?

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

-serge
