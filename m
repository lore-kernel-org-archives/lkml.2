Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab2HCHgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:36:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47172 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2HCHgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:36:38 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Paris <eparis@redhat.com>
Cc: Peter Moody <pmoody@google.com>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@google.com>, viro@zeniv.linux.org.uk,
        jlayton@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: Oops in audit_copy_inode
References: <CALnj_=4r0qdrNUbXmS=q=sk11PZ-Q0z=wPO5wR_DzR4HjnMdqw@mail.gmail.com>
	<CALnj_=5qfAxtKN_T+eoAPCswZPrWmKmOK5HSTwCNZV0s08f_qw@mail.gmail.com>
	<1343837499.18359.7.camel@tucsk.pomaz.szeredi.hu>
	<1343932497.2605.1.camel@localhost>
Date: Fri, 03 Aug 2012 09:37:57 +0200
In-Reply-To: <1343932497.2605.1.camel@localhost> (Eric Paris's message of
	"Thu, 02 Aug 2012 14:34:57 -0400")
Message-ID: <87a9yczaqy.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> I believe this was already found and fixed:
>
> https://lkml.org/lkml/2012/7/25/259
>
> Which was pulled by Linus in:
>
> 3134f37e931d75931bdf6d4eacd82a3fd26eca7c

Okay, yes.  I was actually CC-d on that, but missed the email.

Thanks,
Miklos
