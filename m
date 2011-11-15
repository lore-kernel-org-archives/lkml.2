Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1KOAO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:14:28 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41724 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab1KOAOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:14:24 -0500
X-Sasl-enc: u1SGgC/FsdCHfqUReHOto8rlzfzHmKM3KcNbn8VRsV64 1321316064
Date: Mon, 14 Nov 2011 16:14:19 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: New Char/Misc tree to be added to linux-next
Message-ID: <20111115001419.GA31817@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Arnd and I are going to maintain the drivers/char/* and drivers/misc/*
directories with the goal of getting them under control, or at least a
false-sense of control :)

So could you please add my new git tree:
	git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git

which contains the two branches, "char-misc-linus" to hold patches to
send to Linus for this merge window, and "char-misc-next" to hold
patches for the next merge window.

thanks,

greg k-h
