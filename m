Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0ICNey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:34:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab0ICNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:34:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Fri, 3 Sep 2010 15:34:22 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: mhw@wittsend.com, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201009031413.00266.arnd@arndb.de> <201009030858.08060.gene.heskett@gmail.com>
In-Reply-To: <201009030858.08060.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009031534.22286.arnd@arndb.de>
X-Provags-ID: V02:K0:KGMoKFzJtOQYwyCsdoTOhTOswQ5Z8Lq2rEn9WgbrPq2
 C1CM6PxuWo55A6CRD0HQVbfkrph0sMRI/gmpan6FHJizRvpOd4
 ietCbhQxy6cpBDyKnDvsPJI5Uznoc9ujTTgkMrztjd8cO723cJ
 hBHQLNLGwC6ATwCXrh989TCTHVHH0KTSMYdLLqXg2cHh1hnJGL
 JnflO6g9RTNFqik+ViBAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 September 2010, Gene Heskett wrote:
> Dipping an interested oar in this water, but speaking purely from the user 
> viewpoint;
> 
> That is all well and good I suppose, but please ask yourselves if there are 
> suitable modern replacements for this hardware, and are the drivers 
> available in linux?

As far as I understand, these are all fairly simple (by today's standards)
serial boards, so the assumption is that anyone running a machine with
a 2.6.35 kernel would get a $5 (more for mulitport) USB serial adapter.

> If there are not suitable replacements, buy able at the likes of newegg et 
> all, then this attitude seems a bit premature.
> 
> I presume the same can be said of the rocketport drivers, I haven't seen 
> those boards for sale in yonks, but there are probably at least 1 of them 
> in every television station in the country (USA), doing wire service 
> capture.

Ok, good to know, this is the kind of information I was looking for.
I agree that as long as there are users, we shouldn't just kill the drivers.
For rocket.c, Alan already mentioned that there users left, so it's not
going away.

Note that there are also cases where we know that users exist, but for some
reason they are all stuck on 2.4 kernels or older anyway, so there is no
point in keeping the driver for new kernel releases. Also, we can always
add them back if the situation changes or we hear of users we didn't
know about.

	Arnd
