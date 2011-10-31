Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639Ab1JaWfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:35:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41080 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab1JaWfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <4EAF1FF6.3000500@zytor.com>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
 <4EAF1FF6.3000500@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 15:34:40 -0700
X-Google-Sender-Auth: 6JFzFiMp-Jxu6iwT4adb9U1ZRZw
Message-ID: <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 3:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I use enigmail which is a Thunderbird plugin; it works quite well, but,
> well, it requires Thunderbird.  I think many GUI MUAs have similar
> plugins, but text MTAs might be worse, I don't know.

I have never met a GUI MUA I like before google webmail. And the
advantage of google webmail isn't so much the GUI MUA, as the fact
that it doesn't suck like IMAP, and does the automatic folders and
good handling of archives right.

The reason I switched away from pine was that pine is fine (apart from
the archival thing) if you have all your mail local. But "local mail"
is painful when traveling, or when trying to interact with mail using
a mobile phone etc.

And IMAP mail in turn is totally useless both when traveling *and*
when at home.

So no, thunderbird isn't an option. A command line interface that just
verifies the gpg signature is what I'd like to see.

                    Linus
