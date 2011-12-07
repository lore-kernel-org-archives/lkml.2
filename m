Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1LGH3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:29:40 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:47619 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1LGH3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:29:38 -0500
Date: Wed, 7 Dec 2011 08:29:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Tang Yuantian-B29983 <B29983@freescale.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Tabi Timur-B04825 <B04825@freescale.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, sun york-R58495 <R58495@freescale.com>,
        Durai Kumar-R34055 <r34055@freescale.com>,
        Huang Changming-R66093 <r66093@freescale.com>
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Message-ID: <20111207082924.2f88bd5d@endymion.delvare>
In-Reply-To: <3C06C26914DACA4BB3A368F78CA0B3A71345F2@039-SN1MPN1-004.039d.mgd.msft.net>
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
	<20111207032000.GA17575@ericsson.com>
	<3C06C26914DACA4BB3A368F78CA0B3A71345F2@039-SN1MPN1-004.039d.mgd.msft.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuantian,

Please don't top-post.

On Wed, 7 Dec 2011 05:25:49 +0000, Tang Yuantian-B29983 wrote:
> Hi Guenter,
> 
> I thought you were bore of discussion.
> Do you mind if I post similar patch?

I have no objection, as long as you give proper credit to the original
author.

Note that ultimately you'll have to get Ben Dooks to apply the patch. I
helped with the review but the i2c-mpc driver doesn't actually fall in
my jurisdiction.

-- 
Jean Delvare
