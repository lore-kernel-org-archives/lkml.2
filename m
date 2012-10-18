Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2JRMyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:54:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45213 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2JRMyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:54:32 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87fw5co1qr.fsf@rustcorp.com.au>
References: <20120920232737.GA2953@www.outflux.net> <CAKgNAkheF8=ssrE=_JP-ApDP5zXeHSYVG+0x6Wfd6U28TcPSHQ@mail.gmail.com>
 <87wqyx7me7.fsf@rustcorp.com.au> <CAKgNAkiKajiFxjfBEadXBtD67ApyGEvCa+uoWm7iFBBm0gnshA@mail.gmail.com>
 <87fw5co1qr.fsf@rustcorp.com.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 18 Oct 2012 14:54:11 +0200
Message-ID: <CAKgNAkiv6wNcaTHZJfQChym8oPBhykjCZ6das53rvGSPOMdn0g@mail.gmail.com>
Subject: Re: [PATCH] init_module: update to modern interfaces
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 6:14 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
[...]
>> In fact, the existing EBUSY text seems completely bogus. Should it not
>> read something like
>> "Timeout while trying to resolve a symbol reference by this module."?
>
> Yes, indeed.

Thanks for the confirmation, Rusty.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
