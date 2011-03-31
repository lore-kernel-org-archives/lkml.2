Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1CaPJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:09:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:61799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab1CaPJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:09:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,275,1299484800"; 
   d="scan'208";a="727502570"
Date: Thu, 31 Mar 2011 17:09:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Waldemar.Rymarkiewicz@tieto.com
Cc: arnd@arndb.de, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, matti.j.aaltonen@nokia.com,
        alan@lxorguk.ukuu.org.uk, Sebastian.Chlad@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110331150939.GC2704@sortiz-mobl>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110325142648.GC3879@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
 <201103291305.02293.arnd@arndb.de>
 <20110331141650.GB2704@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Waldemar,

On Thu, Mar 31, 2011 at 05:42:21PM +0300, Waldemar.Rymarkiewicz@tieto.com wrote:
> >My idea of an initial NFC subsystem architecture was actually 
> >the following
> >one:
> >- A core NFC layer against which NFC drivers would register.
> >- A netlink socket for handling the HCI commands. That would 
> >put a big part of the NFC HCI layer in kernel land and could 
> >potentially simplify the existing NFC stacks.
> 
> Shouldn't be better to add a new AF_NFC sock family and then register new LLCP and HCI protocols?
> 
That's the Bluetooth approach, and it works just fine as well.
However, the netlink option for sending commands and receiving answers to/from
a subsystem sounds more appropriate, at least to me.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
