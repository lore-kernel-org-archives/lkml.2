Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2JVXho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:37:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39054 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab2JVXhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:37:43 -0400
Date: Mon, 22 Oct 2012 16:37:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 09/12] tty/console: fix warnings in
 drivers/tty/serial/kgdboc.c
Message-ID: <20121022233740.GA12464@kroah.com>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
 <1348868177-21205-10-git-send-email-arnd@arndb.de>
 <50661A81.7000501@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50661A81.7000501@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 04:45:37PM -0500, Jason Wessel wrote:
> On 09/28/2012 04:36 PM, Arnd Bergmann wrote:
> > The con_debug_leave/con_debug_enter functions are stubbed out
> > by defining them to (0), which causes harmless build warnings.
> > Using proper inline functions is the normal way to deal with
> > this.
> >
> > Without this patch, building the ARM bcm2835_defconfig results in:
> >
> > drivers/tty/serial/kgdboc.c: In function 'kgdboc_pre_exp_handler':
> > drivers/tty/serial/kgdboc.c:279:3: warning: statement with no effect [-Wunused-value]
> > drivers/tty/serial/kgdboc.c: In function 'kgdboc_post_exp_handler':
> > drivers/tty/serial/kgdboc.c:293:3: warning: statement with no effect [-Wunused-value]
> 
> 
> Thanks Arnd!
> 
> I'll put this in kgdb-next for the upcoming merge window, unless Greg pulls it into his queue first.
> 
> Acked-by: Jason Wessel <jason.wessel@windriver.com>

Feel free to take it in through your kgdb tree.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
