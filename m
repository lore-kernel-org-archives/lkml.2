Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386Ab0HFNq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:46:28 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54638 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab0HFNq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:46:26 -0400
Date: Fri, 6 Aug 2010 15:46:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Benton <b3nton@gmail.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make-3.82 and built in firmware
Message-ID: <20100806134624.GA25864@merkur.ravnborg.org>
References: <4C5C03D5.1040108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5C03D5.1040108@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:45:09PM +0100, Andrew Benton wrote:
> Hello World
> I recently upgraded to the latest version of make, 3.82. One of the 
> problems I've had with it is that I can no longer recompile my kernel 
> with built in firmware enabled. If I have 
> CONFIG_FIRMWARE_IN_KERNEL=y
> then the build fails like so:
> 
>   IKCFG   kernel/config_data.h
>   CC      kernel/configs.o
>   LD      kernel/built-in.o
> make[2]: *** No rule to make target `/tmp/linux-build-dir/firmware/radeon/', needed by `firmware/radeon/R100_cp.bin.gen.S'.  Stop.
> make[1]: *** [firmware] Error 2
> make: *** [sub-make] Error 2
> andy:~/save/src/linux-2.6$ 

Thanks for the report.
I saw a similar report whare make 3.82 was accused - maybe this was also from you.

Can you positively confirm that this is a make 3.82 issue - or do you just expect so?

To narrow down this a bit further can I ask you
to send the output of "make -j1 V=1" - especially
the lines before you see the bug.

[-j1 is to force you to avoid parallel makes
 as this may clutter up the output]

Please also post a copy of your configuration
as this allows us to better reproduce what you see.

> Please CC, I'm not subscribed
No problem - we always do so at lkml.

	Sam
