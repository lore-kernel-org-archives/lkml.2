Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0I3XjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:39:25 -0400
Received: from smtp.kponet.fi ([213.145.209.38]:34480 "EHLO smtp.kponet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab0I3XjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:39:23 -0400
Date: Fri, 1 Oct 2010 02:39:21 +0300
From: Sami Farin <hvtaifwkbgefbaei@gmail.com>
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        Sami Farin <hvtaifwkbgefbaei@gmail.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [E1000-devel] Something wrong with tx/rx/sg/gso with dhclient
 etc (Was: Linux 2.6.35.6/e1000e does not receive replies  from DHCP server,
 2.6.33 works)
Message-ID: <20100930233921.vc4yfsa5qcgtquje@m.safari.iki.fi>
Mail-Followup-To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
	Sami Farin <hvtaifwkbgefbaei@gmail.com>,
	linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
	netdev@vger.kernel.org
References: <20100927131935.d5f2ghpfaufiq6yx@m.safari.iki.fi>
 <20100927160731.ehcljyewa5b5wrbm@m.safari.iki.fi>
 <EA929A9653AAE14F841771FB1DE5A13660222E867B@rrsmsx501.amr.corp.intel.com>
 <20100930094417.r6jgrljaer2opekv@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930094417.r6jgrljaer2opekv@m.safari.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 12:44:17 +0300, Sami Farin wrote:
> On Wed, Sep 29, 2010 at 17:40:08 -0600, Tantilov, Emil S wrote:
> > Sami Farin wrote:
> > > False alarm, 2.6.35.6+latest git e1000e does not work any better.
> > > I was just lucky.
> > 
> > Is your `latest git` from Linus or net-next tree? 
> 
> Linus.
> 
> >All of our latest patches go into net-next, so if you haven't already - give it a try and see if it resolves your issue.
> 
> Maybe later =)

I now tried net-next 6d0722a2cec2c23db3b0855ff8bb433175a16b44, it works fine,
with ethtool -K tx/rx on and off.
I used the same .config as with 2.6.35.6 (make oldconfig).
I retested 2.6.33.7, it's still okay.

And unfortunately 2.6.35.6 did not work very well after rebooting,
I had to waste a lot of time playing with -K tx off rx off, -K tx on rx on, etc.
Before it started working, eth0 had interrupts occurring only on CPU0.
CPU1 started getting some usage only after dhclient started working..
Probably irrelevant, but I am running out of ideas.
I have tried e1000e param IntMode 0, 1, 2, no luck.

-- 
Do what you love because life is too short for anything else.

