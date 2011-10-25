Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1JYUOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:14:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62254 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1JYUOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
 <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Tue, 25 Oct 2011 15:14:02 -0500
Message-ID: <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 2:25 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Oct 24, 2011 at 6:28 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>
>> are available in the git repository at:
>>  git://github.com/ericvh/linux.git for-next
>
> So for the merge window, I *really* want the development trees I pull
> from explicitly verified some way.
>
> Now, the p9 patches seem to be small enough, and not core enough, for
> me to care deeply, but I really *really* want to not see unsigned
> github things.
>
> Putting a signed tag on there somewhere that actually signs the top
> commit *and* mentions the repository and branch it is on (ie github)
> kis not wonderfully convenient, but it's at least relatively
> straightforward
>

just to make sure I understand:
I create a tag for the top commit of my for-linus branch using my new
4096 PGP key to sign it and in the description give the github.com URL
and branch name?

>
> (do I have a gpg key I can trust?).
>

We did a key-signing party in Austin a few weeks back, but we've only
got a single link to the larger web of trust (via Olaf).  Should that
be sufficient?

>
> (Also, I'm only seeing about half the patches mentioned in linux-next. Hmm?)
>

okay.  that's weird.  I thought linux-next has been pulling from my
github tree (I sent an updated URL some time back).  I guess I never
really checked to make sure he was getting the updated files.  I'll
rectify this as well.

        -eric
