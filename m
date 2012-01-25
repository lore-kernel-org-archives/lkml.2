Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2AYTQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:16:18 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:58500 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2AYTQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:16:17 -0500
Date: Wed, 25 Jan 2012 11:16:17 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e: repeated eth0: Error reading PHY register
Message-ID: <20120125191616.GJ21370@hexapodia.org>
References: <20120125092101.GA10626@hexapodia.org>
 <804857E1F29AAC47BF68C404FC60A1842437C3@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804857E1F29AAC47BF68C404FC60A1842437C3@ORSMSX102.amr.corp.intel.com>
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 05:00:29PM +0000, Allan, Bruce W wrote:
> >On my Thinkpad X201s running 3.3-rc1 I'm seeing bursts of these:
> >
> >[ 1270.207370] e1000e 0000:00:19.0: eth0: Error reading PHY register
> 
> Please file a bug with this information at
> http://sourceforge.net/tracker/?group_id=42302&atid=447449

Man sourceforge sure has jumped the shark; their signup form requires
"job title" and "company size".  I wonder how many other CEOs of 20,000+
employee companies bother to report ethernet driver bugs.

And we don't have "bugs", we have "artifacts".  Sigh.

Anyways, here you go:
https://sourceforge.net/tracker/?func=detail&aid=3479714&group_id=42302&atid=447449

-andy
