Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321Ab2KABDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 21:03:22 -0400
Received: from ozlabs.org ([203.10.76.45]:34858 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab2KABDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 21:03:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: mtk.manpages@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <CAGXu5jKnok56CHY_YQn9df9MC64TQFexs7fNMmF-NU4Yd+aAig@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com> <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com> <87sj97hs5e.fsf@rustcorp.com.au> <CAGXu5jKnok56CHY_YQn9df9MC64TQFexs7fNMmF-NU4Yd+aAig@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 01 Nov 2012 11:33:02 +1030
Message-ID: <87ehke5e49.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> Rusty,
>
> I haven't seen this land in your modules-next tree. I just wanted to
> make sure it hadn't gotten lost. I'd like to do some kmod tests
> against linux-next, but I've been waiting for this to appear.

Yes, sorting that out now, they should be in tomorrow's linux-next.
And I've sent the ppc patch to linuxppc-dev for Acks.

Thanks for the prod,
Rusty.
