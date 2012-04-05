Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2DEUI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:08:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48970 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2DEUI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:08:27 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [3.4-rc1][Regression][network wireless] 'task xxxx blocked for more than 120 seconds' after resume
Date: Thu, 5 Apr 2012 22:08:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.7.4; x86_64; ; )
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
References: <201204022157.05598.maciej.rutecki@gmail.com> <201204052037.37497.maciej.rutecki@gmail.com> <1333652183.3494.21.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333652183.3494.21.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204052208.21270.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 5 kwietnia 2012 o 20:56:23 Johannes Berg wrote:
> On Thu, 2012-04-05 at 20:37 +0200, Maciej Rutecki wrote:
> > On czwartek, 5 kwietnia 2012 o 12:32:54 Stanislaw Gruszka wrote:
> > > On Tue, Apr 03, 2012 at 10:07:49AM +0200, Johannes Berg wrote:
> > > > -ilw
> > > > +netdev
> > > > 
> > > > I have no idea what this could be, but I'm almost certain it's not
> > > > caused by our wireless driver. Looks more like rtl8169 is to blame.
> > > 
> > > I'm not sure. Looks like there is deadlock or infinite loop in process
> > > that holds rtnl lock. This can be wireless driver, wired driver or
> > > generic network code bug.
> > > 
> > > Maciej, please recompile with CONFIG_LOCKDEP and check if it will not
> > > find any deadlock. If not, when problem will happen please do
> > 
> > Did you mean "CONFIG_LOCKDEP_SUPPORT"?
> 
> No, _SUPPORT means you could enable CONFIG_LOCKDEP, but we would like to
> see this with CONFIG_LOCKDEP enabled.
> 
> johannes

Dmesg when CONFIG_LOCKDEP is set:

http://mrutecki.pl/download/kernel/3.4-rc1/netdev_resume/dmesg-lockdep.txt

Regards

-- 
Maciej Rutecki
http://www.mrutecki.pl
