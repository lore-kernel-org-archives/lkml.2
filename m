Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab1LGDV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:21:28 -0500
Received: from imr4.ericy.com ([198.24.6.9]:37964 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1LGDV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:21:26 -0500
Date: Tue, 6 Dec 2011 19:20:00 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Tang Yuantian-B29983 <B29983@freescale.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sun york-R58495 <R58495@freescale.com>,
        Durai Kumar-R34055 <r34055@freescale.com>,
        Huang Changming-R66093 <r66093@freescale.com>
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Message-ID: <20111207032000.GA17575@ericsson.com>
References: <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
 <1321464509.7847.41.camel@oslab-l1>
 <1321464968.2309.384.camel@groeck-laptop>
 <1321466135.7847.55.camel@oslab-l1>
 <20111116190954.67c846fc@endymion.delvare>
 <1321467638.7847.73.camel@oslab-l1>
 <20111116201048.4b7877dd@endymion.delvare>
 <1321470915.7847.122.camel@oslab-l1>
 <20111116201847.6b11dc7f@endymion.delvare>
 <3C06C26914DACA4BB3A368F78CA0B3A7134583@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3C06C26914DACA4BB3A368F78CA0B3A7134583@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 09:52:36PM -0500, Tang Yuantian-B29983 wrote:
> Hi Jean Delvare,
> 
> We agree to apply this patch. Do you have any concerns?
> Although Guenter said that he give up, I don't think he really meant it.

I did mean it, otherwise I would not have said it.

Guenter

> Also it is improper if I repost similar patch.
> I tested this patch, it works.
> 
> Regards,
> Yuantian
> 
> > -----Original Message-----
> > From: Jean Delvare [mailto:khali@linux-fr.org]
> > Sent: 2011年11月17日 3:19
> > To: sun york-R58495
> > Cc: guenter.roeck@ericsson.com; Tabi Timur-B04825; linux-
> > i2c@vger.kernel.org; linux-kernel@vger.kernel.org; Tang Yuantian-B29983
> > Subject: Re: [PATCH] i2c/busses: (mpc) Add support for
> > SMBUS_READ_BLOCK_DATA
> > Really, please. I understand you're only trying to help and understand
> > the patch, but at some point, if you have zero knowledge about the topic,
> > you're not the right person to review the patch, period. You are still
> > welcome to test the patch if you can and want, that's a completely
> > different task.
> > 
> > --
> > Jean Delvare
> 
> 
