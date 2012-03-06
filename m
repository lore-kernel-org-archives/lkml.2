Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074Ab2CFS6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:58:50 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:39303 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2CFS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:58:48 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2012 13:58:48 EST
Date: Tue, 6 Mar 2012 10:49:28 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e: repeated eth0: Error reading PHY register
Message-ID: <20120306184928.GA16849@hexapodia.org>
References: <20120125092101.GA10626@hexapodia.org>
 <804857E1F29AAC47BF68C404FC60A1842437C3@ORSMSX102.amr.corp.intel.com>
 <20120125191616.GJ21370@hexapodia.org>
 <20120126231913.GB24483@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126231913.GB24483@hexapodia.org>
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 03:19:13PM -0800, Andy Isaacson wrote:
> On Wed, Jan 25, 2012 at 11:16:16AM -0800, Andy Isaacson wrote:
> > On Wed, Jan 25, 2012 at 05:00:29PM +0000, Allan, Bruce W wrote:
> > > >On my Thinkpad X201s running 3.3-rc1 I'm seeing bursts of these:
> > > >
> > > >[ 1270.207370] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > > 
[snip]
> > https://sourceforge.net/tracker/?func=detail&aid=3479714&group_id=42302&atid=447449

FWIW, this log message is not showing up in 3.3-rc4.

... Which is very surprising since there are changes AFAICS, but it's
definitely not there...

-andy
