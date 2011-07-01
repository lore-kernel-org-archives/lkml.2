Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1GAUxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:53:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:39837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab1GAUxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:53:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,460,1304319600"; 
   d="scan'208";a="22499410"
Date: Fri, 1 Jul 2011 13:53:44 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <e.a.b.piel@tudelft.nl>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc5+ : khubd blocked
Message-ID: <20110701205344.GA18229@xanatos>
References: <20110701200800.GB17865@xanatos>
 <Pine.LNX.4.44L0.1107011637091.1624-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107011637091.1624-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 04:40:04PM -0400, Alan Stern wrote:
> On Fri, 1 Jul 2011, Sarah Sharp wrote:
> > Do you mind if I just take your patch and make a proper fix out of it?
> 
> Don't bother; I'll send it in to Greg momentarily (along with your 
> Tested-by if you don't mind).

Sure, that works.

Sarah Sharp
