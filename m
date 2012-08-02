Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2HBLBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 07:01:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:46274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2HBLBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:01:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192418256"
Date: Thu, 2 Aug 2012 19:01:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Joe Perches <joe@perches.com>, Karsten Keil <isdn@linux-pingi.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:ISDN SUBSYSTEM" <netdev@vger.kernel.org>
Subject: Re: [PATCH] isdnloop: fix and simplify isdnloop_init()
Message-ID: <20120802110122.GA21708@localhost>
References: <20120802040158.GA11860@localhost>
 <20120802104456.GA21537@localhost>
 <20120802105736.GJ4352@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802105736.GJ4352@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 01:57:36PM +0300, Dan Carpenter wrote:
> On Thu, Aug 02, 2012 at 06:44:56PM +0800, Fengguang Wu wrote:
> > [Add more CC]
> > 
> 
> That's not helpful...  Resend the patch to netdev in a way that
> applies.

OK, sorry...
