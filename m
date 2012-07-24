Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2GXUBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:01:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab2GXUBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:01:22 -0400
Message-ID: <500EFF10.3050607@redhat.com>
Date: Tue, 24 Jul 2012 14:01:20 -0600
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc
 definition
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com> <20120724182409.GB10534@zod.bos.redhat.com> <20120724183230.GC10534@zod.bos.redhat.com> <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com> <20120724190302.GE10534@zod.bos.redhat.com> <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com> <500EF43C.3060200@redhat.com> <CA+55aFwvidWyBK5+U_4r5uibSkk4A-1jbnY-i9BtRgbx=Odo7w@mail.gmail.com> <500EF6EF.4080708@redhat.com> <CA+55aFzfQUYs3eo=O8BYBNPZB_ie5dAWSxCCcHWHNMeeozr7_g@mail.gmail.com>
In-Reply-To: <CA+55aFzfQUYs3eo=O8BYBNPZB_ie5dAWSxCCcHWHNMeeozr7_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/12 13:43, Linus Torvalds wrote:
>
> I think we should likely keep __FD_SETSIZE, since that really is a
> valid kernel value (that the kernel actually uses). The rest looks
> *entirely* bogus.
I can certainly live with that.

Josh, looks like you've got marching orders :-)

Of course there'll be some kind of fallout, there always is.



> And the reason I emphasize the "entirely" is literally that the kernel
> headers don't even define the full __FD_SET/CLR/ISSET() functionality.
I know.  When this first came to my attention I feared I'd find another 
implementation of FD_{SET,CLR}/ISSET.

Jeff
