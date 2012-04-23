Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2DWLHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:07:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2DWLHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:07:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Date: Mon, 23 Apr 2012 11:06:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Shijie <b32955@freescale.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de> <20120422235506.d3377f0e.akpm@linux-foundation.org> <20120423072839.GC4568@pengutronix.de>
In-Reply-To: <20120423072839.GC4568@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204231106.31574.arnd@arndb.de>
X-Provags-ID: V02:K0:2zwONi7FcySwTL6GkPux3sG1DUPMXKRVq0pD9YUjCYM
 CSGB7IrWgBy9h5fnjlHj++sHz9RiJYNlt2km7Tfnl+PYxENi4k
 YPYQndaUzqETK2jZnkHiKD8dczVMDgKKTaCYTSxXTrkUXoXaK9
 MUh5aWihGiCkzn4TwEM7jrVeCDK6zsb4iKCI0QCCTGzIWNcWtW
 eEjpoOGQp0J1zXxXrfr5X2fE9xaXS/3QTeRUuNN7bnvsofw3wo
 8aCyXIoUCKLNl4mHsCKnqn82/UdBmyEnQuhqFBf+NLSfK4MyCL
 nv5MdBtYhxTIR/uv+FJShkv7+6YMofFrvQ5Yqsm9sdE46JSQKx
 oo9oh0hBvIYaSu06Eg8k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2012, Wolfram Sang wrote:
> > But ./lib/ does seem rather a strange place for it.  Perhaps we need a
> > drivers/lib/ or something.  We can use ./lib/ for now - it can always
> > be moved later on.
> 
> The first version had it in drivers/base/ but that also felt strange.
> I like drivers/lib/. Arnd, do you agree? Shall I resend?

I think lib/ is fine, but I also suggested putting it there ;-)

If Andrew or someone else feels strongly about it, we can of course
change it again before I submit it to Linus.

	Arnd
