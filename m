Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1EUMno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:43:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:60525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab1EUMnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:43:43 -0400
Message-ID: <4DD7B374.7040907@infradead.org>
Date: Sat, 21 May 2011 09:43:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [git pull] FireWire updates post 2.6.39
References: <20110521120718.6a67029e@stein>
In-Reply-To: <20110521120718.6a67029e@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 21-05-2011 07:07, Stefan Richter escreveu:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following updates for the IEEE 1394 (FireWire) subsystem.
> They contain small fixes and some optimizations, e.g. to CPU utilization
> during isochronous I/O.
> 
> The changes in {drivers/media/dvb,sound}/firewire/ have been Cc'd to
> linux-media and alsa-devel but I did not request explicit Acks.  There
> are no conflicts yet and are unlikely to arise during the merge window.
> 

>  drivers/media/dvb/firewire/firedtv-avc.c |   15 +------
>  drivers/media/dvb/firewire/firedtv-fw.c  |    1 +

The changes on the above dvb stuff are due to the API changes and looks fine
for me.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
