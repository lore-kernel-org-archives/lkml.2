Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2JREmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:42:06 -0400
Received: from ozlabs.org ([203.10.76.45]:40763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2JREmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:42:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+55aFxo-b3nUAWhG0N7hJkH1goStvBBTCT7XWGD+RJLG0=fsQ@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com> <20121018005432.GA20163@kroah.com> <CA+55aFxo-b3nUAWhG0N7hJkH1goStvBBTCT7XWGD+RJLG0=fsQ@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 18 Oct 2012 15:04:26 +1030
Message-ID: <877gqoo0tp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Wed, Oct 17, 2012 at 5:54 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>
>>> One of the main sane use-cases for module signing is:
>>>
>>>  - CONFIG_CHECK_SIGNATURE=y
>>>  - randomly generated one-time key
>>>  - "make modules_install; make install"
>>>  - "make clean" to get rid of the keys.
>>>  - reboot.
>>
>> I want that too, but right now 'make clean' leaves the keys around,
>> which seems a bit dangerous to me.
>
> Oh, yes, we should make sure the key file gets cleaned up at "make clean".

I left it at distclean, figuring the temporary key is a bit like the
.config.  But it's trivial to change if people think that's unnatural.

Cheers,
Rusty.
