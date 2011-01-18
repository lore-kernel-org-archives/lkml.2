Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1ARBJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:09:24 -0500
Received: from ozlabs.org ([203.10.76.45]:56487 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1ARBJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:09:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] param: add null statement to compiled-in module params
Date: Tue, 18 Jan 2011 11:39:21 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>
References: <1294230424-4089-1-git-send-email-linus.walleij@stericsson.com> <201101171011.16182.rusty@rustcorp.com.au> <4D33F9DD.2020504@stericsson.com>
In-Reply-To: <4D33F9DD.2020504@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101181139.21779.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011 06:42:13 pm Linus Walleij wrote:
> On 01/17/2011 12:41 AM, Rusty Russell wrote:
> > On Wed, 5 Jan 2011 10:57:04 pm Linus Walleij wrote:
> >    
> >> Add an unused struct declaration statement requiring a
> >> terminating semicolon to the compile-in case to provoke an
> >> error if __MODULE_INFO() is used without the terminating
> >> semicolon. Previously MODULE_ALIAS("foo") (no semicolon)
> >> compiled fine if MODULE was not selected.
> >>      
> > I really prefer the other way; make everyone use a semicolon.
> >    
> 
> That's what it does. Currently the kernel allows you to
> write MODULE_ALIAS("bar") sans semicolon if you
> compile in the module statically...
> 
> Or am I getting things wrong?

No, I was.  Sorry, I should read more carefully.

Applied, thanks!
Rusty.
