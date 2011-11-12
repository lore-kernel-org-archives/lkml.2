Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1KLTbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 14:31:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44686 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1KLTbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 14:31:12 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz4xcD-+9pTyXgPwoCGEffL1ydcdxdTCEB8hRKzZfqVwA@mail.gmail.com>
References: <20111026202235.GA20928@havoc.gtf.org>
	<1319969101.5215.20.camel@dabdike>
	<CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
	<4EAF1731.2070908@zytor.com>
	<CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
	<4EAF1FF6.3000500@zytor.com>
	<CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com>
	<alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm>
	<4EAF66C7.6080909@zytor.com>
	<CA+55aFwycceEN7itYama6H4gwAK-OQdqZ5uo9Pdg9ATqPTPtWQ@mail.gmail.com>
	<CA+8MBbLQm3OP5t8diSznURHtiRprqJEz1WerhddnUhqExLj_5w@mail.gmail.com>
	<CA+55aFz4xcD-+9pTyXgPwoCGEffL1ydcdxdTCEB8hRKzZfqVwA@mail.gmail.com>
Date: Sat, 12 Nov 2011 21:31:10 +0200
Message-ID: <CAMP44s1PCcFwtUge-CFaxBPnpRZyzOBGxgE0xFG_imiiFtwkzw@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        david@lang.hm, James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 7:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The LKML thing is why I really love how gmail works. LKML just goes
> into the black hole that is the gmail thing, and I never see it. But
> then, when I get cc'd about something in the middle of a thread when a
> question comes up - I just magically see the whole thread without
> having to look around in other folders or anything like that.
>
> I'm sure 'notmuch' etc does that too, but pine sure never did. If I
> made my filters automatically move lkml posts to my lkml folder, by
> the time I got cc'd, I had to go back to that folder to see the
> history of the thread.

'notmuch' is the only mail client that I know does that (because it
has tags). So I do exactly the same in Gmail than in notmuch; "mark as
archived", and then I don't see the messages in my inbox, but the
actual mail never really moves, it just doesn't have the 'inbox' tag
any more.

Moreover, searching all your mail is very fast, just like in Gmail.

One benefit is that it's open source, so you add your own key
bindings, or whatever you like, and unlike projects like GNOME, they
have similar development practices as in git; you send patches to the
mailing list, no bugzilla crap.

Of course, it only works with local mail (maildir), but you could use
mbsync (as Theodore Tso suggested). That's what I do in my mail setup;
I use mbsync to synchronize ~/onlinemail with the IMAP server, and
after I archive mail, I run a script that moves that mail to ~/mail,
so it's removed from the server on the next sync.

Cheers.

-- 
Felipe Contreras
