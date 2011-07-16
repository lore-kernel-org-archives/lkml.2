Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1GPCOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 22:14:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37209 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751883Ab1GPCOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 22:14:32 -0400
Date: Sat, 16 Jul 2011 11:13:46 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110716021343.GB17883@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025328.GJ2927@ponder.secretlab.ca>
 <20110715044800.GK32716@opensource.wolfsonmicro.com>
 <20110715182954.GB2833@ponder.secretlab.ca>
 <20110716014536.GA17883@opensource.wolfsonmicro.com>
 <20110716020618.GB16014@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716020618.GB16014@ponder.secretlab.ca>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 08:06:18PM -0600, Grant Likely wrote:
> On Sat, Jul 16, 2011 at 10:47:09AM +0900, Mark Brown wrote:

> > Still, the merge window is getting near so I guess I'll make the change :/

> :)  Indeed.  We can merge without and then enjoy the argument at our
> leisure after the merge window.

I've actually already made the change, just testing now.
