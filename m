Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2CEJWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:22:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab2CEJWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:22:48 -0500
Date: Mon, 5 Mar 2012 10:22:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Nikolai Kondrashov <spbnick@gmail.com>
Subject: Re: [Bug #42649] Regression 3.2 -> 3.3-rc1 commit b4b583d4 inet/media
 keyboard: stuck "extra" keys
In-Reply-To: <20120304180628.5444b453@ws>
Message-ID: <alpine.LNX.2.00.1203051022310.23367@pobox.suse.cz>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera> <hq7dqombK_C.A.UsF.mG9UPB@chimera> <alpine.LNX.2.00.1203042201220.23367@pobox.suse.cz> <20120304180628.5444b453@ws>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012, Duncan wrote:

> > Nikolai already submitted a fix for b4b583d4e here: 
> > http://www.spinics.net/lists/linux-input/msg19542.html
> > 
> > I will be queuing that shortly, and will try to make sure that it
> > makes it into 3.3 still (otherwise 3.3-stable).
> > 
> > Duncan, I'd be interested whether it fixes the issue you are
> > reporting as well.
> 
> Just finished testing.  Confirming.
> 
> 3.3-rc6 unpatched (still) bad,
> 
> 3.3-rc6 with that patch applied, good.

Awesome, thanks a lot for quick verification.

-- 
Jiri Kosina
SUSE Labs
