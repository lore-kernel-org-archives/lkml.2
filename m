Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab2AXC5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:57:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36887 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab2AXC5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:57:37 -0500
MIME-Version: 1.0
In-Reply-To: <201201061200.44183.arnd@arndb.de>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com>
	<CAOMZO5BQhcxViN3KnjhzF9hL1w04egkmb9njc7sDUB0GFdgBog@mail.gmail.com>
	<20120106050355.GA7633@kroah.com>
	<201201061200.44183.arnd@arndb.de>
Date: Tue, 24 Jan 2012 00:57:36 -0200
Message-ID: <CAOMZO5A9qpgAhL9NZXL3uYqSVjDPchdmBMySzjD=uenndjY4bw@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>
Cc: netdev@vger.kernel.org, gwingerde@gmail.com, larry.finger@lwfinger.net,
        davem@davemloft.net, bhutchings@solarflare.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Jan 6, 2012 at 10:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> I think that is true for the majority of stuff we have under drivers/misc
> anyway. I had done the same patch that Fabio sent a couple of months ago
> but then forgot about it, so here is a wholehearted
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> for the new patch. It fixes a real problem, and we applied a similar patch
> in drivers/mfd as 8a0a8e8e already. We probably still want to find a better
> home for drivers that frequently get selected by other subsystems as you
> said, but that is an independent issue. I don't see why anyone would
> need a way to disable all MISC drivers at once, when the only thing that
> (in theory) connects them is that they are all different from everything
> else.

Do you have any objections about this patch?

Thanks,

Fabio Estevam
