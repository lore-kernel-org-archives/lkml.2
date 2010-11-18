Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab0KRQrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:47:52 -0500
Received: from kroah.org ([198.145.64.141]:54446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759522Ab0KRQru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:47:50 -0500
Date: Thu, 18 Nov 2010 08:45:52 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101118164552.GC2855@kroah.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:46:37AM -0800, Luis R. Rodriguez wrote:
> Can Linux help in any way? What if we used staging for a common driver
> architecture for different OSes? Most of those staging drivers already
> have some sort of OS agnostic cruft, why not try to help hardware
> vendors by providing them with a common OS agnostic solution they can
> share? Is this not out turf? If its not, are we perfectly OK in being
> second citizens so long as the driver eventually gets done on proper
> upstream Linux ? I'm not OK with it and hence my e-mail. I'm looking
> for ideas and thoughts on this. Please no trolls, would really just
> like some constructive discussions on this. As I see it maybe we can
> move some of this OS agnostic crap into staging, and then use spatch
> to write tools to de-unwrap crap to Linux specific stuff and help
> maintain it. What this does is it moves OS agnostic crap out as a
> community effort to help aid proper development and porting for Linux.
> Since we'd maintain the crap / scripts / de-wrappers, we'd likely be
> able to get drivers quicker and can have a framework to help companies
> who still [1] need to support other Operating Systems.

No, staging is for gettingn code into, or out of, the kernel tree, not
for anything else.

I have allowed it to be used to hold drivers in that are not
"acceptable", while another driver was written by others from scratch to
work properly on that hardware, and then the original one is dropped.
That's ok, as there is a time-limit on how long the code lives in the
staging tree.

But to try to use it to create a multi-os solution, no, that's not what
staging is for.

Also, please review the past multi-os driver initiatives that have
sprung up over the years (about 1 every 10 years it seems).  Please
learn from the past as to why those have failed every single time, and
why we don't want to even try to do that again.

thanks,

greg k-h
