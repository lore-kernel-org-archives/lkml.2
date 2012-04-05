Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2DES43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 14:56:29 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:58074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab2DES41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 14:56:27 -0400
Message-ID: <1333652183.3494.21.camel@jlt3.sipsolutions.net>
Subject: Re: [3.4-rc1][Regression][network wireless] 'task xxxx blocked for
 more than 120 seconds' after resume
From: Johannes Berg <johannes@sipsolutions.net>
To: maciej.rutecki@gmail.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Thu, 05 Apr 2012 20:56:23 +0200
In-Reply-To: <201204052037.37497.maciej.rutecki@gmail.com> (sfid-20120405_203812_209408_5261E33E)
References: <201204022157.05598.maciej.rutecki@gmail.com>
	 <1333440469.3574.0.camel@jlt3.sipsolutions.net>
	 <20120405103254.GE2378@redhat.com>
	 <201204052037.37497.maciej.rutecki@gmail.com>
	 (sfid-20120405_203812_209408_5261E33E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-05 at 20:37 +0200, Maciej Rutecki wrote:
> On czwartek, 5 kwietnia 2012 o 12:32:54 Stanislaw Gruszka wrote:
> > On Tue, Apr 03, 2012 at 10:07:49AM +0200, Johannes Berg wrote:
> > > -ilw
> > > +netdev
> > > 
> > > I have no idea what this could be, but I'm almost certain it's not
> > > caused by our wireless driver. Looks more like rtl8169 is to blame.
> > 
> > I'm not sure. Looks like there is deadlock or infinite loop in process
> > that holds rtnl lock. This can be wireless driver, wired driver or
> > generic network code bug.
> > 
> > Maciej, please recompile with CONFIG_LOCKDEP and check if it will not
> > find any deadlock. If not, when problem will happen please do
> 
> Did you mean "CONFIG_LOCKDEP_SUPPORT"?

No, _SUPPORT means you could enable CONFIG_LOCKDEP, but we would like to
see this with CONFIG_LOCKDEP enabled.

johannes

