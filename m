Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0GKOVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 10:21:06 -0400
Received: from kroah.org ([198.145.64.141]:38260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab0GKOU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 10:20:59 -0400
Date: Sun, 11 Jul 2010 07:16:14 -0700
From: Greg KH <greg@kroah.com>
To: Michael Leun <lkml20100708@newton.leun.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NET_NS: unregister_netdevice: waiting for lo to become free
	(after using openvpn) (was Re: sysfs bug when using tun with
	network namespaces)
Message-ID: <20100711141614.GC30015@kroah.com>
References: <loom.20100708T183152-326@post.gmane.org> <20100709235744.GA12752@kroah.com> <20100710101540.2799c9ef@xenia.leun.net> <20100710140800.GA20424@kroah.com> <20100710165208.59272ae6@xenia.leun.net> <20100710235323.5336f627@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100710235323.5336f627@xenia.leun.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 11:53:23PM +0200, Michael Leun wrote:
> But: should'nt kernel clean up after process when it exits?
> And/or: Should'nt kernel clean up if last process in network namespace
> exits - there is nothing left which might use that interface?!

Yes, you are correct.  Care to resend all of this to the
network-namespace developer(s) and the netdev mailing list so that the
correct people are notified so they can fix it all?

thanks,

greg k-h
