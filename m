Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1LSUbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:31:09 -0500
Received: from smtp.timeweb.ru ([92.53.116.15]:52444 "EHLO smtp.timeweb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1LSUbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:31:07 -0500
Subject: Re: drivers/net/usb/asix: strange numeration of eth interfaces
From: Igor Egorkin <igor@egorkin.ru>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, grundler@chromium.org
In-Reply-To: <20111219.141128.1563372305361818137.davem@davemloft.net>
References: <1324280623.19383.8.camel@igor-pc.lan>
	 <20111219.141128.1563372305361818137.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 00:31:01 +0400
Message-ID: <1324326661.3124.31.camel@igor-pc.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 14:11 -0500, David Miller wrote:
> What you're seeing isn't strange, it depends upon what ethernet devices were
> visible when you installed your machine.
> 
> 'udev' in userspace remembers the mappings from ethernet addresses to
> device names, and renames devices as the system comes up to what it
> first saw them as, based upon the MAC address.
> 
> So one possibility is that there were 2 other ethernet or wireless devices
> in your system at install time, so the one that the ASIX device got was
> 'eth2'.
> 
> Therefore that is the device name it will have until you tell 'udev' to
> do otherwise.

Dear David,
Thank you very much!
It helps.
Sorry for my stupidity.




On Mon, 2011-12-19 at 10:37 -0800, Grant Grundler wrote:
> The goal(s) of your email/patch aren't 100% clear to me.

I was told to buy a lot of these adapters, but at first to test them. In
the debian stable there is old driver which does not see these adapters.
Driver from the vendor looks suspicious. I thought it better to get
driver from the current linux-3.2-rc6. But by mistake I thought I found
a bug, and decided to tell you. Time running out, and I cannot think
anything better than write to this mailing list. The next time I'll be
more careful, I will think ten times before worry developers. Sorry!

--
Igor E.


