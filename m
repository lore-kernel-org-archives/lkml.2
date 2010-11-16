Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab0KPIAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:00:03 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56567 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab0KPIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:00:01 -0500
Date: Mon, 15 Nov 2010 23:59:59 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Incorrect size checks on mmap() for sysfs PCI resource files
	is breaking X?
Message-ID: <20101116075959.GS14383@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20101116072247.GQ14383@tux1.beaverton.ibm.com> <AANLkTin16PNdYh61Zhy=5ttMrL-VuSYYkCRybXo6wFo=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin16PNdYh61Zhy=5ttMrL-VuSYYkCRybXo6wFo=@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 05:53:35PM +1000, Dave Airlie wrote:
> On Tue, Nov 16, 2010 at 5:22 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> > Hi,
> >
> > I just loaded 2.6.37-rc2 on my machines, and I noticed that X no longer starts.
> > Running an strace of the X server shows that it's doing this:
> 
> Can you poinpoint when it went wrong? does 2.6.36 work okay?

Yes, 2.6.36 is ok.  2.6.37-rc1 was ok too.

> Just trying to figure out where the regression arrived.

Looks like it's commit 3b519e4ea618b6943a82931630872907f9ac2c2b which went in
11 Nov 2010.  I just submitted a patch that fixes it, at least for me.

--D
