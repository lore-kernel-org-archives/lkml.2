Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2DIPXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:23:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2DIPXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:23:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: No more Linux 2.4 releases
Date: Mon, 9 Apr 2012 15:22:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20120409133050.GA17473@1wt.eu>
In-Reply-To: <20120409133050.GA17473@1wt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204091522.38021.arnd@arndb.de>
X-Provags-ID: V02:K0:hUitV0vRI/FHyoPeXEUV7NtuBzqIkYFohiIzaVH8QEH
 qIkDz2xkrm5xYQbYznEoRhh/9Np3GGG59SNyOn8Q2LNs7IbSWH
 Zef8YhDBMFT0KG5WUe8fgPO07iENwmmvVYSGpEQD28MfifcqJw
 pQLoIfpMyWAU8umf8OWIdd4XwvEXquKE6lLA5vCApj9qz8pf4V
 5Ax6YUPPmnxR8UYq7sXcjlC85bRz/nYKCR2KqJ6EwKAR5vpRDm
 o6B1CDfXZFR9DDj+Tn8zOaB3PVw14mkuXiy0z0Bu21p2WEj6MS
 Ia6LIsxmACY2WwTNBk5v8QrlDMifzxj/tQUCg/8CFG5htO7vWE
 eHLihRr7ZwsGTi1klbj8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, Willy Tarreau wrote:
> However since the break-in, I was surprized to see that some users have
> asked where to find the 2.4 git tree to pick some fixes from it. After
> discussing with several of them, it appears that they're not really
> interested in releases, rather just in having a place where fixes are
> centralized and that the git tree is perfect for this. So I revived the
> git tree in my account and will probably push a patch there once in a
> while if people ask for this, but with no guarantees.

Thanks for putting it back. I was recently in the situation of trying
to figure out where some code came from. Having an easy way to see
if it was in 2.4 definitely helps there.

I'm still looking for a copy of the "historic" kernels that we used
to have on kernel.org, but that's not your problem.

	Arnd
