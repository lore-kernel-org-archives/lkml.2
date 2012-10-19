Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2JSC2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:28:22 -0400
Received: from ozlabs.org ([203.10.76.45]:60415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2JSC2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:28:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+5PVA4fE7uaxNobBMtUs7QUWA2XfM_2oKtLhb7DFRisJLy+4Q@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com> <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com> <CA+5PVA4fE7uaxNobBMtUs7QUWA2XfM_2oKtLhb7DFRisJLy+4Q@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 19 Oct 2012 11:18:03 +1030
Message-ID: <87lif3p9rw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@gmail.com> writes:
> It might even be able to be moved entirely into scripts/Makefile.modinst
> but I haven't gotten that far yet.

Thanks, I'll add this.

Note it was word-wrapped here though :(

Cheers,
Rusty.
