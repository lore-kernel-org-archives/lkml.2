Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2JSLoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:44:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44801 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2JSLox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <87lif3p9rw.fsf@rustcorp.com.au>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<87txtso9xw.fsf@rustcorp.com.au>
	<CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
	<871ugwny1n.fsf@rustcorp.com.au>
	<CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
	<CA+5PVA4fE7uaxNobBMtUs7QUWA2XfM_2oKtLhb7DFRisJLy+4Q@mail.gmail.com>
	<87lif3p9rw.fsf@rustcorp.com.au>
Date: Fri, 19 Oct 2012 07:44:52 -0400
Message-ID: <CA+5PVA6noOyUJBTCYyAHgtJun1DPRmNQ4NxpvVepAVY12vjiwQ@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
From: Josh Boyer <jwboyer@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 8:48 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Josh Boyer <jwboyer@gmail.com> writes:
>> It might even be able to be moved entirely into scripts/Makefile.modinst
>> but I haven't gotten that far yet.
>
> Thanks, I'll add this.

Excellent.

> Note it was word-wrapped here though :(

Sigh.  Sorry, Rusty.  I thought I had gmail's kinks worked out.

josh
