Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1EJXc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:32:56 -0400
Received: from cpc7-stkp7-2-0-cust918.10-2.cable.virginmedia.com ([86.22.251.151]:51750
	"EHLO freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753464Ab1EJXcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:32:55 -0400
X-Greylist: delayed 1438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 May 2011 19:32:55 EDT
Date: Wed, 11 May 2011 00:08:32 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-i2c@fluff.org>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, eric.y.miao@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
Message-ID: <20110510230832.GE634@freya.fluff.org>
References: <1304003746-12127-1-git-send-email-haojian.zhuang@gmail.com>
 <20110502092734.GV15795@trinity.fluff.org>
 <20110502114616.7813da79@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502114616.7813da79@endymion.delvare>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 11:46:16AM +0200, Jean Delvare wrote:
> On Mon, 2 May 2011 10:27:34 +0100, Ben Dooks wrote:
> > On Thu, Apr 28, 2011 at 11:15:44PM +0800, Haojian Zhuang wrote:
> > > Both AP and CP are contained in Marvell PXA910 silicon. These two ARM
> > > cores are sharing one pair of I2C pins.
> > > 
> > > In order to keep I2C transaction operated with atomic, hardware lock
> > > (RIPC) is required. Because of this, bus lock in AP side can't afford
> > > this requirement. Now hardware lock is appended.
> > > 
> > > Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> > > Cc: Ben Dooks <ben-linux@fluff.org>
> > > Cc: Jean Delvare <khali@linux-fr.org>
> > 
> > Right, this looks like a reasonable explanation of what is going on here
> > and if Jean is happy with the core changes I'll look at where the driver
> > change can go.
> 
> Yes I am!
> 
> Let me know if you want me to take the core change in my tree or if you
> prefer to have it in yours to avoid a dependency.

if it'll go in my tree ok, then yes.
Will publish a new tree soon.
