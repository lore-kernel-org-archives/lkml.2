Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab2CTDsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:48:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42483 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752456Ab2CTDsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:48:03 -0400
Message-ID: <1332215281.7847.54.camel@joe2Laptop>
Subject: Re: [PATCH wireless-next 2/3] ath5k: Introduce _ath5k_printk to
 reduce code/text
From: Joe Perches <joe@perches.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Mar 2012 20:48:01 -0700
In-Reply-To: <CAJ-Vmom4n7Sk5P=HMb+Z-FNyfyk87Xbf5Q1kPA4i2eXwQ72kXQ@mail.gmail.com>
References: <cover.1332116921.git.joe@perches.com>
	 <b157e2d1a746733d1814b9726f326d52d36da2fc.1332116921.git.joe@perches.com>
	 <CAJ-Vmo=ceSV38vQGfs8cKJScWjYF4kbQdK3+JJvQLCmnURaEwA@mail.gmail.com>
	 <1332134336.23125.60.camel@joe2Laptop>
	 <CAJ-Vmom4n7Sk5P=HMb+Z-FNyfyk87Xbf5Q1kPA4i2eXwQ72kXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 20:39 -0700, Adrian Chadd wrote:
> On 18 March 2012 22:18, Joe Perches <joe@perches.com> wrote:
> >> Otherwise compiling in debugging will cause a _lot_ of spurious
> >> register reads to occur that are then tossed. This was one of the big
> >> reasons for instability and slow performance when AH_DEBUG was
> >> enabled.
> > That doesn't make any sense in this case.
> >
> > It's either a call to printk or _ath5_printk
> > but it's still a call to a function.
> 
> The FreeBSD HAL used to be like this. I changed it so it didn't
> evaluate the arguments before it figured out whether or not to do the
> (k)printf().
> 
> I'm just pointing it out as you're (currently) knee deep in the
> debugging code and it may be useful for you to also think about
> implementing.

I see, thanks for the heads-up.

The no_printk function could/does eval args
and can cause those sorts of issues.

So care does need to be used.

cheers, Joe

