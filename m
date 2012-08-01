Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2HAR2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:28:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48331 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2HAR16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <1343837499.18359.7.camel@tucsk.pomaz.szeredi.hu>
References: <CALnj_=4r0qdrNUbXmS=q=sk11PZ-Q0z=wPO5wR_DzR4HjnMdqw@mail.gmail.com>
 <CALnj_=5qfAxtKN_T+eoAPCswZPrWmKmOK5HSTwCNZV0s08f_qw@mail.gmail.com> <1343837499.18359.7.camel@tucsk.pomaz.szeredi.hu>
From: Peter Moody <pmoody@google.com>
Date: Wed, 1 Aug 2012 10:27:27 -0700
Message-ID: <CALnj_=5NiDjePNY2P9pjFstP8STzzQWM_5kG2UbWiyCKJAfXqw@mail.gmail.com>
Subject: Re: Oops in audit_copy_inode
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>,
        viro@zeniv.linux.org.uk, Eric Paris <eparis@redhat.com>,
        miklos@szeredi.hu
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 9:11 AM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> Hi Peter,
>
> Thanks for the report.
>
> Here's a patch.  I haven't tested it but I'm pretty confident that it
> fixes the bug.
>
> Thanks,
> Miklos

Ack. I can confirm that I don't Oops with this patch.

Thanks!

Cheers,
peter

-- 
Peter Moody      Google
Security Engineer  pgp:0xC3410038
