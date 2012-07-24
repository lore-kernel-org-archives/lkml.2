Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2GXTqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:46:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:29425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab2GXTqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:46:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="176947874"
Date: Tue, 24 Jul 2012 12:46:09 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] xhci: EHCI/XHCI ports switching on Intense-PC.
Message-ID: <20120724194609.GA6681@xanatos>
References: <5004454E.9030903@compulab.co.il>
 <20120717045416.GJ7599@xanatos>
 <50065E5A.2040103@compulab.co.il>
 <20120718165916.GA30828@xanatos>
 <500D3998.7010705@compulab.co.il>
 <20120723174406.GG32758@xanatos>
 <500E61E2.9080406@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500E61E2.9080406@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:50:42AM +0300, Denis Turischev wrote:
> On 07/23/2012 08:44 PM, Sarah Sharp wrote:
> > Did you try disabling the wake on bits in the port status registers?  I
> > would prefer that solution if it works.
> No, I didn't. Why we need to disable wake on capabilities?

My theory was that the xHCI host controller was waking up the system
because one of the wake on bits was set.  But you said that didn't help,
so we'll just switch the ports over on shutdown.

Sarah Sharp
