Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2CUF0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:26:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5433 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2CUF0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:26:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 20 Mar 2012 22:26:12 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 21 Mar 2012 10:55:58 +0530
Subject: RE: [PATCH] mfd: Add support for TPS65090
Thread-Topic: [PATCH] mfd: Add support for TPS65090
Thread-Index: Ac0GsP7RO87dBdnqSQyqGQDN/CHRIgAcgdUQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3127DD1@BGMAIL02.nvidia.com>
References: <1331876419-10478-1-git-send-email-vbyravarasu@nvidia.com>
 <20120316204015.GW20524@sortiz-mobl>
 <D958900912E20642BCBC71664EFECE3E6DD3127A5B@BGMAIL02.nvidia.com>
 <20120320155708.GF17818@sortiz-mobl>
In-Reply-To: <20120320155708.GF17818@sortiz-mobl>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Samuel.

> -----Original Message-----
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Tuesday, March 20, 2012 9:27 PM
> To: Venu Byravarasu
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] mfd: Add support for TPS65090
> 
> Hi Venu,
> 
> On Mon, Mar 19, 2012 at 02:08:31PM +0530, Venu Byravarasu wrote:
> > Hi Samuel,
> >
> > Thanks for your prompt reply.
> >
> > > The patch looks good. Could you please provide me with a better description
> > > for this device (sub devices, etc...) ?
> >
> > TPS65090 is a PMIC offered by TI. It contains:
> > 	a. 3 Step-Down Converters:
> > 	b. 2 Always On LDO's
> > 	c. 7 Current Limited Load Switches
> >
> > With this patch adding basic PMIC functionality along with interrupt controller
> support.
> > Once this patch gets merged, will add regulator driver for this device.
> Applied, thanks.
> 
> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
