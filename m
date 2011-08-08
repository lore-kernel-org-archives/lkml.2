Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1HHT0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:26:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15174 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab1HHT0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:26:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 08 Aug 2011 12:26:09 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben-i2c@fluff.org>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>
Date: Mon, 8 Aug 2011 12:26:04 -0700
Subject: RE: [PATCH] dt: add empty of_get_property for non-dt
Thread-Topic: [PATCH] dt: add empty of_get_property for non-dt
Thread-Index: AcxVD5sBdeSFpli1QSOgnepQW5qjMAA8TN1A
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049F172239@HQMAIL01.nvidia.com>
References: <1312584630-23371-1-git-send-email-swarren@nvidia.com>
 <4E3EA340.2010100@gmail.com>
In-Reply-To: <4E3EA340.2010100@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Herring wrote at Sunday, August 07, 2011 8:38 AM:
> On 08/05/2011 05:50 PM, Stephen Warren wrote:
> > The patch adds empty function of_get_property for non-dt build, so that
> > drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> >
> > This also fixes the current Tegra compile problem in linux-next.
>
> You could just use of_property_read_u32 in the driver. It already has
> empty version and will simplify the driver code some.

Yes, that would also work.

Grant, Ben, do you have a preference for which option to choose?

Thanks.

> > diff --git a/include/linux/of.h b/include/linux/of.h
...
> > +static inline const void *of_get_property(const struct device_node *node,
> > +				const char *name,
> > +				int *lenp)
> > +{
> > +	return NULL;
> > +}
> > +

-- 
nvpublic

