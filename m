Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab1JZN5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:57:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44581 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab1JZN5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwHw=xSdk7VtHCiVKzfzvGS=d8hXwwfaPEcU=P6PDarsA@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
 <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
 <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
 <CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
 <FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com> <CA+55aFwHw=xSdk7VtHCiVKzfzvGS=d8hXwwfaPEcU=P6PDarsA@mail.gmail.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Wed, 26 Oct 2011 08:57:29 -0500
Message-ID: <CAFkjPTmJNv9WFfhL6RRN3mVGniU57Sxj-mLBfN1-KeR8RKxf9g@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 7:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 26, 2011 at 2:48 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>
>> What's the preferred maintainer workflow?  I had been fetching and then rebasing, which seemed to keep my shortlog clean of merge commits and the outstanding patches towards the top.  Should I just be pulling from upstream and not caring about the merge commits?
>
> Hell no.
>
> Why do you pull from upstream? What does that add to *your*
> development? Don't do it. Pick a place to start, and just develop
> things. Ask me to pull.
>

okay, I guess I was always updating to make sure I was integration
testing against the tip, but I can do that in throw-away branches so
that the branch I ask you to pull from keeps somewhat more sane.

            -eric
