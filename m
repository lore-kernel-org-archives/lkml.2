Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2FRGXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:23:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:16527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2FRGXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:23:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157534502"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: RE: [PATCHv2] power_supply: Register battery as a thermal zone
Thread-Topic: [PATCHv2] power_supply: Register battery as a thermal zone
Thread-Index: AQHNTQs71I137SCSiUGywBoF1Z1h2Jb/PkgAgABc6RA=
Date: Mon, 18 Jun 2012 06:23:47 +0000
Message-ID: <20ADAB092842284E95860F279283C5642825FA@BGSMSX101.gar.corp.intel.com>
References: <1336576007-8772-1-git-send-email-jenny.tc@intel.com>
 <20120618042927.GA25372@lizard> <20120618061916.GA27786@lizard>
In-Reply-To: <20120618061916.GA27786@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5I6O2pR018992

> -----Original Message-----
> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> Sent: Monday, June 18, 2012 11:49 AM
> To: Tc, Jenny
> Cc: linux-kernel@vger.kernel.org; R, Durgadoss
> Subject: Re: [PATCHv2] power_supply: Register battery as a thermal zone
> 
> On Sun, Jun 17, 2012 at 09:29:28PM -0700, Anton Vorontsov wrote:
> [...]
> > +static int psy_register_thermal(struct power_supply *psy) {
> > +	int i;
> > +
> > +	/* Register battery zone device psy reports temperature */
> > +	for (i = 0; i < psy->num_properties; i++) {
> > +		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
> > +			psy->tzd = thermal_zone_device_register(psy-
> >name, 0,
> 
> Oh, and just FYI, there was a (char *) cast for psy->name, but I removed it.
> The cast should be not needed w/ this patch:
> 
> http://lkml.org/lkml/2012/6/18/28

Thanks. I applied it locally when I noticed the warning.

> 
> Thanks,
> 
> --
> Anton Vorontsov
> Email: cbouatmailru@gmail.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
