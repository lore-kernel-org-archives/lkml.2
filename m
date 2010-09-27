Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab0I0Tvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:51:38 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53168 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933389Ab0I0Tvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:51:37 -0400
Date: Mon, 27 Sep 2010 21:51:35 +0200
From: Florian Mickler <florian@mickler.org>
To: tmhikaru@gmail.com
Newsgroups: gmane.linux.kernel
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100927215135.3d11d587@schatten.dmk.lab>
In-Reply-To: <20100927163208.GA4892@roll>
References: <20100927003608.GA20395@kroah.com>
	<20100927163208.GA4892@roll>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 12:32:08 -0400
tmhikaru@gmail.com wrote:

> 	I'm not exactly sure what's going on here and I'd like some help
> figuring out what is. For some inexplicable reason, ever since I started
> using the 2.6.35.x series with the 2.6.35.3 release, my loadaverages tend to
> bounce anywhere from as low to .2 to 1.5 - constantly, while the machine
> seems idle. Consistently, there are no programs in D state in ps aux output,
> no cpu hogging programs running in top, nothing I can see that should
> explain the bizzarely high load average. *Something* is wrong beyond the
> mere loadaverage numbers going crazy however, since timed runs of kernel
> compiles done with my distro's kernel and 2.6.35.5 show that while there is
> no *apparent* use of cpu or disk showing in vmstat while the machine is
> idle, the compiles on the newer kernel are taking approximately twice as
> long as before. Now, while I could try to figure out what patch started the
> problem, I think it would be a better idea for me to make sure I'm looking
> for the actual problem in the right place. Therefore, I know that cpu use,
> disk I/O, and the kernel can drive the load average up. Of these things, cpu
> use and disk I/O are trackable in top/ps output (eg, a process in D state is
> waiting on the disk to do something and can't sleep.) but I don't know if
> there's any easy way to determine if the kernel itself is doing something
> that's driving up the load average. It's perplexing me that I can see the
> loadaverage constantly bouncing about but can't seem to find any reason why
> it is doing so.

I can't comment on the bouncing part, but increased load average is
partly bisected down in Bug 16525 (unexpected high load since 2.6.35
Bug 16525)[1]. Maybe you are seeing something similiar? 

> 
> 	If you have any tips or recommendations on what I should use to
> investigate this further, please let me know. Once I have ensured to my own
> satisfaction that I'm not doing something bizzare that's screwing up my
> machine, I'll make a detailed bug report and start on figuring out how to
> use git bisect.
> 
> 	Tim McGrath
> 
