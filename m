Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1AGVeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:34:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1AGVeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:34:23 -0500
Date: Fri, 7 Jan 2011 13:24:54 -0800
From: Greg KH <gregkh@suse.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Sathya Perla <sathyap@serverengines.com>,
        Ajit Khaparde <ajitk@serverengines.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Jin <joe.jin@oracle.com>,
        Subbu Seetharaman <subbus@serverengines.com>,
        Sarveshwar Bandi <sarveshwarb@serverengines.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [064/152] driver/net/benet: fix
 be_cmd_multicast_set() memcpy bug
Message-ID: <20110107212454.GB19958@suse.de>
References: <20110106002500.GA3172@kroah.com>
 <20110106002302.664621558@clark.site>
 <20110107193907.GH32717@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107193907.GH32717@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:39:07PM -0500, Paul Gortmaker wrote:
> [[stable] [064/152] driver/net/benet: fix be_cmd_multicast_set() memcpy bug] On 05/01/2011 (Wed 16:22) Greg KH wrote:
> 
> > 2.6.36-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > 
> > From: Joe Jin <joe.jin@oracle.com>
> > 
> > [ Upstream commit 3fd40d0ceac9c234243730f4d7a6ffdb2fd3023a ]
> 
> This one should be 408cc293c29ada769ae772420a39961320da1854.
> 
> Figured I'd run reviewbot on the others and check for valid IDs.
> There are a couple others that have the same issue:
> 
> 0066
> bridge-fix-IPv6-queries-for-bridge-multicast-snoopin.patch
> 	should be 76d661586c8131453ba75a2e027c1f21511a893a
> 
> 0072
> l2tp-Fix-modalias-of-l2tp_ip.patch
> 	should be e8d34a884e4ff118920bb57664def8a73b1b784f
> 
> 0073
> x25-decrement-netdev-reference-counts-on-unload.patch
> 	should be 171995e5d82dcc92bea37a7d2a2ecc21068a0f19
> 
> 0076
> net-Fix-header-size-check-for-GSO-case-in-recvmsg-af.patch
> 	should be 1f18b7176e2e41fada24584ce3c80e9abfaca52b

Thanks, I'll go fix them up.

David, looks like something broke in your scripts :(

greg k-h
