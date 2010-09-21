Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0IUEcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:32:51 -0400
Received: from xenotime.net ([72.52.115.56]:45897 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753021Ab0IUEcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:32:43 -0400
Date: Mon, 20 Sep 2010 21:32:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
Message-Id: <20100920213234.ca0e3684.rdunlap@xenotime.net>
In-Reply-To: <1285042724-19135-1-git-send-email-justinmattock@gmail.com>
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 21:18:44 -0700 Justin P. Mattock wrote:

> Below you will find a patch containing updates to broken web addresses in the kernel.
> Some were easy to piece together, but some were knowhere to be found..Keep in mind this was 
> just a grep for "http", not sure how many other protocol's in there are working or not..
> Thanks for the replies, if you see anything that I might have missed let me know...
> (as for the signed-off's not sure if it's the best way, but figured if you replied
> with a correct link, then why not!!).  

I think that you need to read Documentation/SubmittingPatches:
section 13) When to use Acked-by: and Cc:

to know when to use those keywords.  I expect that most of these are
inappropriate.


> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Matt Turner <mattst88@gmail.com>
> Signed-off-by: Dimitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Ben Pfaff <blp@cs.stanford.edu>
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Acked-by: Hans J. Koch <hjk@linutronix.de>


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
