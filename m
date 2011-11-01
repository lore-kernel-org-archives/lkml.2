Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1KADbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:31:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41710 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1KADba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
 <4EAF1FF6.3000500@zytor.com> <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com>
 <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 20:31:08 -0700
X-Google-Sender-Auth: mvmUUtpy679nt8iVmzP8GRr77Uc
Message-ID: <CA+55aFy=Wz4zxjoPJer=OfA2Jsh1FA_ahUpa8sw=5UJuAyEsFQ@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: david@lang.hm
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 7:17 PM,  <david@lang.hm> wrote:
>
> what IMAP servers have you used? I find that with a good IMAP server I can
> get away with _very_ little processing power in the client and get good
> performance (I still am using pine, but with a cyrus IMAP server)

I've used pine (and then alpine) to cyrus servers too. That was what
LF used to have on the server side. It absolutely sucked.

That combination is supposed to do server-side searching etc, but you
couldn't tell from the performance. It was disgusting.

I'm sure it works much better with a fast local network, but quite
frankly, that obviates the need for IMAP in the first place. If you
have your mail locally, there are better models than IMAP for handling
it.

So the only situation I've found IMAP reasonable has been at corporate
settings where you're not talking DSL or cable modem speeds, but use
IMAP as a way to avoid NFS-mounting the mail spool, which is even
worse. But actually working over slowish internet connections? No
thank you.

                         Linus
