Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0EJMeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:34:03 -0400
Received: from ozlabs.org ([203.10.76.45]:42647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab0EJMd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:33:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warnings after merge of the rr tree
Date: Mon, 10 May 2010 22:03:53 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100510134409.4bbf1873.sfr@canb.auug.org.au> <20100510134620.2e06495b.sfr@canb.auug.org.au>
In-Reply-To: <20100510134620.2e06495b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005102203.54784.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 01:16:20 pm Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Mon, 10 May 2010 13:44:09 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > drivers/acpi/debug.c:141: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > 
> > Introduced by commit a1c3b92923eced4ee034fa15bf058f91e435e08c ("param:param_ops").
> 
> Also
> 
> drivers/message/fusion/mptbase.c:112: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'

Thanks, these are harmless, and I had followup patches outside linux-next
which resolve them.

I've now included them in the linux-next part of the series.

Thanks,
Rusty.
