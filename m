Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2JDJVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:21:09 -0400
Received: from mail.x86-64.org ([217.9.48.20]:37662 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab2JDJVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:21:08 -0400
Date: Thu, 4 Oct 2012 11:20:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: tty_init_dev: 24 callbacks suppressed
Message-ID: <20121004092055.GA21028@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seeing this on today's Linus tree:

[   24.048278] tty_init_dev: 24 callbacks suppressed
[   45.630349] tty_init_dev: 3 callbacks suppressed

It is either from that WARN_RATELIMIT thing or the printk_ratelimited
further below in tty_init_dev but I don't know for sure because the
actual text message from both printk's doesn't come out in dmesg - only
that something got suppressed.

And it quiets down later, after the machine has finished booting. Still,
this doesn't tell me anything about any issue. So what's up?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
