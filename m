Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab2JVBZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:25:08 -0400
Received: from ozlabs.org ([203.10.76.45]:36925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab2JVBZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:25:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <2140.1350645706@warthog.procyon.org.uk>
References: <87txtrpb1t.fsf@rustcorp.com.au> <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com> <87a9vko0z7.fsf@rustcorp.com.au> <20121018121154.GE2934@hansolo.jdub.homelinux.org> <CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com> <2140.1350645706@warthog.procyon.org.uk>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Oct 2012 10:21:35 +1030
Message-ID: <87bofvjse0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> > (Side note: I hope people realize that the random key is generated
>> > with a 100-year lifespan. So if you build a kernel today, you do
>> > potentially have a "year-2112 problem". I'm not horribly worried, but
>> > I *am* a bit worried about 32-bit time_t overflow and I hope 32-bit
>> > openssl doesn't do anything odd)
>> 
>> Yep, David's original patch had that problem; he fixed the kernel's x509
>> handling to use struct tm, not time_t, and now it Just Works.
>
> That's assuming that 32-bit *openssl* gets it right when generating the key.

Yes, I am assuming that.  What openssl did you think I ran on my 32-bit
kernel? :)

Cheers,
Rusty.
