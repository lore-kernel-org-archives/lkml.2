Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1KADnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:43:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48679 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab1KADnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <4EAF66C7.6080909@zytor.com>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
 <4EAF1FF6.3000500@zytor.com> <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com>
 <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm> <4EAF66C7.6080909@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 20:42:57 -0700
X-Google-Sender-Auth: Yx68Kj5Bh_8HePGUbQCMxgKGWak
Message-ID: <CA+55aFwycceEN7itYama6H4gwAK-OQdqZ5uo9Pdg9ATqPTPtWQ@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: david@lang.hm, James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 8:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I use IMAP on my phone, and with Thunderpants... I mean Thunderbird...
> and it works quite nicely.

Including things like searching lkml etc?

I've been successful in using IMAP for just reading my inbox (even
over a cell network). Then IMAP is reasonably fine, at least if you do
client-side caching.

But not for actual real *work*, where I actually search for specific
email authors and words in the body? Not so much.

Maybe it's because I'm used to having all my mail locally, but
searching all my emails is one of my most common operations. The gmail
web interface does that fine. IMAP has never worked for me, despite
some client/server combinations allegedly supporting server-side
searches. Maybe I never hit the right combination, but I tested things
that were *supposed* to do it.

Actually, most of my attempts at using IMAP have been unacceptably
slow even when I don't do searches. I used to do huge inboxes, which
brought just about anything to a standstill. I only got rid of my
habit of big inboxes thanks to another gmail feature - you don't have
to save your non-inbox email in a folder, you can just "archive" it
and it goes away but is still easily searchable.

                         Linus
