Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab1CaPaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:30:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:63183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320Ab1CaPaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:30:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,276,1299484800"; 
   d="scan'208";a="621675108"
Date: Thu, 31 Mar 2011 17:30:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Waldemar.Rymarkiewicz@tieto.com
Cc: arnd@arndb.de, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, matti.j.aaltonen@nokia.com,
        alan@lxorguk.ukuu.org.uk, Sebastian.Chlad@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110331153010.GD2704@sortiz-mobl>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110325142648.GC3879@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
 <201103291305.02293.arnd@arndb.de>
 <20110331141650.GB2704@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
 <20110331150939.GC2704@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085F0FE7C@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481085F0FE7C@EXMB04.eu.tieto.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 06:24:50PM +0300, Waldemar.Rymarkiewicz@tieto.com wrote:
> Hi Samuel,
> 
> >That's the Bluetooth approach, and it works just fine as well.
> >However, the netlink option for sending commands and receiving 
> >answers to/from a subsystem sounds more appropriate, at least to me.
> 
> I haven't used netlink in practice, so just wondering why netlink. I assume, then, it's more suitable :)
>
Have a look at the wireless nl80211.c implementation. It's a good example for
that sort of usage.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
