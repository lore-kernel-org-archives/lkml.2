Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab1JaWVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:21:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38790 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934198Ab1JaWVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <4EAF1731.2070908@zytor.com>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <4EAF1731.2070908@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 15:21:00 -0700
X-Google-Sender-Auth: 23pfBQvCJ6TaZCGjfOXamkdlcuE
Message-ID: <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 2:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> What client are you using (or are you using the gmail web interface?)

I'm using the gmail web interface, but I can save the email
individually for gpg checking. It's just that when I do that, no sane
tool will actually check it (ie there is no equivalent of "gpg
--verify" for that mbox) that I've found.

And it's kind of sad when the gpg inative nterfaces are better than
some other tool. gpg is famous for having a *horrible* user interface.

                        Linus
