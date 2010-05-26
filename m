Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158Ab0EZGfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:35:38 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:5996 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574Ab0EZGfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:35:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALdd/EtbstI2/2dsb2JhbACeGXK/aQ6FBQQ
Date: Wed, 26 May 2010 08:35:34 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the watchdog tree with Linus' tree
Message-ID: <20100526063534.GI3972@infomag.iguana.be>
References: <20100526133815.e62bacb8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526133815.e62bacb8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> These are two versions of the same patch.  I used the version from Linus'
> tree - but I do need to ask what is the point of having a patch in
> linux-next for two days and then submitting a different version of the
> patch to Linus?  The changes are not insignificant. Both patches have the
> same Author date and SOB etc lines.

The one that went to Linus is the correct one.
I must apologise, I indeed fucked things up. I wasn't completely happy
with Wolfram's patch, changed it, Wolfram pointed out some things that
still could be improved and then we tested the final version, saw that
everything was OK and much beter then what we had.
And then I made the error to want to rush it in during this merge window
still (due to the fact that we are allready reviewing this driver for a
long time). So yes sorry, this was the wrong thing to do (well, not having
a better driver in, but the way the testing should have been done and the
correct process that should have been followed).

I will clean up the watchdog-next tree.

Sorry again,
Wim.

