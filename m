Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1JZM2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:28:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52915 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab1JZM2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
 <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com> <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2011 14:28:15 +0200
X-Google-Sender-Auth: hKRmn8vIfEGasIFrFTGBq8Zcs8s
Message-ID: <CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 10:14 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>
>> (Also, I'm only seeing about half the patches mentioned in linux-next. Hmm?)
>>
>
> okay.  that's weird.  I thought linux-next has been pulling from my
> github tree (I sent an updated URL some time back).  I guess I never
> really checked to make sure he was getting the updated files.  I'll
> rectify this as well.

This turns out to be just me being stupid. I just checked the changes
in fs/9p, and not net/9p, so I didn't find Dan Carpenters patches in
net. And because you had rebased them, I was looking at that (partial)
shortlog when comparing, rather than the full one.

Anyway, pulled now. I do wish people didn't rebase so much, it makes
all the commits different in linux-next wrt what I actually end up
getting..

                Linus
