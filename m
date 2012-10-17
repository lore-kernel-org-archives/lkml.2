Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab2JQU4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:56:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54697 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2JQU4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:56:47 -0400
Date: Wed, 17 Oct 2012 13:56:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] staging: dgrp: Add missing #include
 <linux/uaccess.h>
Message-ID: <20121017205643.GA23462@kroah.com>
References: <1348771106-14105-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdXpAkyc+xDWTnmvNn-4WcHL7DE-NryAmFdwvCY_UbY9QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXpAkyc+xDWTnmvNn-4WcHL7DE-NryAmFdwvCY_UbY9QQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 02:40:30PM +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 27, 2012 at 8:38 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On m68k:
> 
> Now also in mainline, cfr.
> http://kisskb.ellerman.id.au/kisskb/buildresult/7344531/
> 
> > drivers/staging/dgrp/dgrp_mon_ops.c: In function ‘dgrp_mon_read’:
> > drivers/staging/dgrp/dgrp_mon_ops.c:304: error: implicit declaration of function ‘copy_to_user’
> > drivers/staging/dgrp/dgrp_specproc.c: In function ‘config_proc_write’:
> > drivers/staging/dgrp/dgrp_specproc.c:470: error: implicit declaration of function ‘copy_from_user’
> > drivers/staging/dgrp/dgrp_tty.c: In function ‘drp_wmove’:
> > drivers/staging/dgrp/dgrp_tty.c:1284: error: implicit declaration of function ‘copy_from_user’
> > drivers/staging/dgrp/dgrp_tty.c: In function ‘get_modem_info’:
> > drivers/staging/dgrp/dgrp_tty.c:2267: error: implicit declaration of function ‘put_user’
> > drivers/staging/dgrp/dgrp_tty.c: In function ‘set_modem_info’:
> > drivers/staging/dgrp/dgrp_tty.c:2283: error: implicit declaration of function ‘access_ok’
> > drivers/staging/dgrp/dgrp_tty.c:2283: error: ‘VERIFY_READ’ undeclared (first use in this function)
> > drivers/staging/dgrp/dgrp_tty.c:2283: error: (Each undeclared identifier is reported only once
> > drivers/staging/dgrp/dgrp_tty.c:2283: error: for each function it appears in.)
> > drivers/staging/dgrp/dgrp_tty.c:2287: error: implicit declaration of function ‘get_user’
> > drivers/staging/dgrp/dgrp_tty.c: In function ‘dgrp_tty_digigetedelay’:
> > drivers/staging/dgrp/dgrp_tty.c:2474: error: implicit declaration of function ‘copy_to_user’
> > drivers/staging/dgrp/dgrp_tty.c: In function ‘dgrp_tty_ioctl’:
> > drivers/staging/dgrp/dgrp_tty.c:2618: error: ‘VERIFY_WRITE’ undeclared (first use in this function)
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Yes, now in my tree, will go to Linus this week.

thanks,

greg k-h
