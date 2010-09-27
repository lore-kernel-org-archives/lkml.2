Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab0I0V7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:59:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47209 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0I0V7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:59:47 -0400
X-Originating-Ip: 216.16.235.2
Date: Mon, 27 Sep 2010 17:59:41 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext3 filesystem corruption in user mode linux
Message-ID: <20100927215941.GA20458@foursquare.net>
References: <20100924041410.GA18040@foursquare.net> <20100924060557.GA21238@foursquare.net> <20100924064446.GA22588@foursquare.net> <AANLkTinQ20uSgFP5KV17B0J0v8Y0zAg=AgAd_kf+4Bh0@mail.gmail.com> <20100927211842.GA19667@foursquare.net> <AANLkTinYjJ8m6UjsR++zFCxo4jecDEzCAX_F_CF6NwZV@mail.gmail.com> <20100927212650.GA20386@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927212650.GA20386@foursquare.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 05:26:50PM -0400, Chris Frey wrote:
> > Hmm, maybe this issue affects only your configuration.
> > When I have some spare time I'll try to trigger this on my setup.
> 
> That would be great.  Let me know if you need any specific data from my end.

One data point that I'm finding so far, is that it is easier to trigger
in 2.6.35.x than 2.6.32.x.  It also doesn't seem to be dependent on the
version of the host kernel.  I can reproduce it running 2.6.35.4 or
2.6.32.22.

If you want a small gentoo starting point, I have a 56M compressed
ext3 gentoo guest filesystem I can share with those who wish to test.
I don't want to make it available to everyone, due to size.

- Chris

