Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab0LNSML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:12:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65366 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab0LNSMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:12:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type:content-transfer-encoding;
        b=YLRyF//ifPDjdBnIF0INmWsj4q2HmIvySqIEAnX2Tu3VhTXB9w6II3yxVUQ0kzlygq
         I00WRj3iPLxXvoFxecdyrUaRXOhjUc3hrV4d3um6FZXS//eJQYVIjBkj62G6Xla/Crd6
         QVAqtyTVQcDRlw0aYMl7go0VFRqzAbyyNJ2XQ=
From: Ben Gamari <bgamari@gmail.com>
To: ltuikov@yahoo.com, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
In-Reply-To: <865543.43677.qm@web31802.mail.mud.yahoo.com>
References: <865543.43677.qm@web31802.mail.mud.yahoo.com>
User-Agent: Notmuch/0.5-17-g2d1420b (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 Dec 2010 13:12:00 -0500
Message-ID: <87fwu05imn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Dec 2010 09:25:12 -0800 (PST), Luben Tuikov <ltuikov@yahoo.com> wrote:
> --- On Mon, 12/13/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> > Your insinuations against the character of many
> > long-standing Linux
> > developers, based on their refusal to accept your
> > submission,
> 
> No, not submission. The fact is that no one bothered to review the
> code. It was simply flat out NAK-ed it in just four minutes, fronting
> one of their co-workers with the defunct driver already in.
> 
> It would've been a different story if Greg, Alan and you and anyone
> else willing, had provided a technical review, and /then/ reject
> it--the rejection reason would've been clearer to everyone, than
> taking all this thread to get to.
> 
> Greg didn't review it and rejected it 4 minutes after posting. Alan
> didn't review it and after I posted the 18 technical reasons (my 2nd
> post in this thread replying to Greg's) said this:
> 
> > Your driver may be the best on the planet - who knows - 
> Obviously he didn't review it.

This is may be true, perhaps he didn't look at the code. This is not
because he doesn't have confidence that your driver is well-written or
holds a grudge against you. The reason for this NAK is policy: a driver
already exists. In the kernel we work with what already exists, even if
it may be more difficult than the alternative.

I looked at your code; from my uninformed perspective it looks very
nice. You clearly do have a good understanding of the stack and your
code looks refreshingly clean. That being said, a driver covering the
same devices already exists in the tree. There may be good technical
reasons why this driver is inferior, but these are merely reasons to fix
the existing code, not rip it out to be replaced wholesale.

At this point you have two options: You can continue to argue that the
world is against you, which as we seen makes neither side happy and only
makes your life as a contributor harder, or you can try to work what you
have into something that will fit with the existing codebase. I suggest
the latter. Further arguing is not going to change this policy. That
being said, your expertise is certainly needed and it is in everyone's
best interest to ensure that the UAS driver in the kernel is the best
that it can be.

> I've already stated that there had never been an agenda about uasp.c
> and Linux. The uasp.c driver was written over most of a Saturday (when
> I had time and uas.c showed itself to be defunct).  Since uasp.c is a
> working driver and correctly implemented in terms of UAS, USB, SCSI,
> the kernel and it's layers, I thought it would be *helpful* and
> *useful* to people--that's all.
> 
Improving code is very useful. History has taught us that flat-out
rewriting components just makes things messier.

> The driver was rejected flat out only after 4 minutes after submission
> claiming that there is a driver in the kernel that "does the exact
> same thing".  I then provided 18 technical reasons as to why uas.c
> does NOT in fact do the exact same thing to which Greg responded with:
> 
> > But again, this driver is not acceptable as-is, sorry.
> 
> Why would he have to apologize? Anyway, to which you responded with
> not knowing which driver is good.
> 
He apologized because he knows you put a lot of time, effort, and
thought into a piece of code which we cannot accept. It is unfortunate
that this is the case but such is the reality of large-scale software
development.

> So after such a blatant refusal to even give a technical review of the
> driver, it had me thinking: why would that be?
> 
Easy question. See above. In short, there is no sense to give a
technical review of code which we ultimately won't be able use.
Sometimes this sort of thing happens. If I were you, I would accept what
people have been telling you and try to integrate portions of your
patch into the existing UAS driver. This will cause the least pain/most
benefit to all involved.

- Ben
