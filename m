Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1BJPSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:18:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:21361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab1BJPSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 10:18:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'208";a="656406909"
Subject: Re: [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period
 of time tanks causing contant drops
From: wwguy <wey-yi.w.guy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shawn Starr <shawn.starr@rogers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110209231526.cce3e7b7.akpm@linux-foundation.org>
References: <613373.34172.qm@smtp106.rog.mail.re2.yahoo.com>
	 <20110209231526.cce3e7b7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 07:16:24 -0800
Message-ID: <1297350984.20613.68.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 23:15 -0800, Andrew Morton wrote:
> (cc linux-wireless)
> 
> On Sun, 06 Feb 2011 22:54 -0500 Shawn Starr <shawn.starr@rogers.com> wrote:
> 
> > 
> > Using a Intel Corporation PRO/Wireless 5100 AGN [Shiloh] card after rebooting 
> > and a period of of seveal hours signal begins to drop to low levels:
> > 
> > 
> > wlan0     IEEE 802.11abgn  ESSID:"XXXXXXXX"  
> >           Mode:Managed  Frequency:2.462 GHz  Access Point: AA:BB:CC:DD:EE:FF   
> >           Bit Rate=11 Mb/s   Tx-Power=15 dBm   
> >           Retry  long limit:7   RTS thr:off   Fragment thr:off
> >           Power Management:off
> >           Link Quality=12/70  Signal level=-98 dBm  
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:35   Missed beacon:0
> > 
> > ...
> > 
> >           Link Quality=12/70  Signal level=-98 dBm  
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:40   Missed beacon:0
> > 
> > I start seeing lots of Invalid misc errors and connection drops. If I reboot, 
> > then signal will be back to normal for a period of time again.
> > 
> > My official kernel is from Fedora rawhide (2.6.38-0.rc3.git4.1.fc15.x86_64)
> > 
> > Anyone else notice poor link/signal levels?
> > 
> > .37 showed no such issues.


did not see anything special from the log, is any environment or
condition changed? what AP you are using?

Thanks
Wey

