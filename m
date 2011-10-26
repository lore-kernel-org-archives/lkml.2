Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1JZUGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:06:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:26655 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab1JZUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:06:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,411,1315206000"; 
   d="scan'208";a="78313383"
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
From: wwguy <wey-yi.w.guy@intel.com>
To: David Rientjes <rientjes@google.com>, johannes.berg@intel.com
Cc: Gene Smith <gds@chartertn.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>
References: <j881g5$tdf$1@dough.gmane.org>
	 <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Oct 2011 13:00:16 -0700
Message-ID: <1319659216.14693.26.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes, any idea?

Thanks
Wey

On Tue, 2011-10-25 at 23:27 -0700, David Rientjes wrote:
> On Wed, 26 Oct 2011, Gene Smith wrote:
> 
> > Now after upgrade to Ubuntu 11.10 when resume from suspend, wifi fails to
> > reconnect saying waiting for authentication. When I use older kernel, 2.4.38
> > instead of the new 3.0.0, it still works OK. If using ethernet, after wake
> > from suspend it always works OK.
> > 
> 
> So we need to bisect between 2.4.38 and 3.0.0? :)  I'm running ubuntu 
> 11.10 on a home laptop so I'll give this a try as well when I can if I can 
> put up with unity for that long.
> 
> > More details on this bug are here
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/880648
> > and here
> > https://bugzilla.redhat.com/show_bug.cgi?id=7374
> > 
> > Tried new Ubuntu kernel 3.1-rc10 did not help. Did not try an alternate kernel
> > with Fedora 15.
> > 
> > The common failure messages seen with Ubuntu and Fedora is this:
> > 
> > <info> (wlan0): device state change: need-auth -> failed (reason 'no-secrets')
> > [60 120 7]
> > Oct 24 01:20:00 hplt NetworkManager[1016]: <warn> Activation (wlan0) failed
> > for access point (dbnet)
> > 
> > After this occurs, no further attempt to authenticate wifi occur and a red X
> > appears over the wifi icon. I must then use ethernet (or reboot).
> > 
> 
> Adding wireless folks to the cc.


