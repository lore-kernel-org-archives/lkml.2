Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1CUJdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 05:33:07 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:52540 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab1CUJdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 05:33:05 -0400
Date: Mon, 21 Mar 2011 11:32:57 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: balbi@ti.com, Stefan Bigler <stefan.bigler@keymile.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110321093255.GE1837@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D8121F6.9060600@keymile.com>
 <20110317000408.GA18911@kroah.com>
 <4D8389EC.5030704@keymile.com>
 <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
 <20110318180657.11570887@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318180657.11570887@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 06:06:57PM +0000, Alan Cox wrote:
> > I had the same problem while I was working at Nokia developing the N900.
> > I even sent a patch (twice) with Alan Cox on the loop but nothing has
> > happened.
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/02347.html
> 
> is I assume the thread you are talking about - which ground to a halt
> without actually figuring out what you were seeing and what was really
> going on.
> 
> http://permalink.gmane.org/gmane.linux.usb.general/28976
> 
> would be the second generation one which was somewhat longer after I
> ceased to be tty maintainer so I can't really say it never got upstream.
> 
> I still think its the right thing to do, so perhaps it's worth reposting
> it, especially if it fixes this case too.

Ok, I'll update that patch and re-send. I'll compile test on x86 and
boot test on an ARM box, so it would be cool to have Acks from several
people before applying, just in case.

-- 
balbi
