Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0JEVlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:41:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2679 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0JEVlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:41:47 -0400
Subject: RE: [PATCH v2] iio: light: Adding driver for ISL29018 ALS
From: Joe Perches <joe@perches.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: "jic23@cam.ac.uk" <jic23@cam.ac.uk>, Andrew Chew <AChew@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <E88A1D35AF5437468E5B14C7C4BA61C702D2D2620A@HQMAIL01.nvidia.com>
References: <1286313561-6456-1-git-send-email-rklein@nvidia.com>
	 <1286314517.2156.50.camel@Joe-Laptop>
	 <E88A1D35AF5437468E5B14C7C4BA61C702D2D2620A@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 14:41:43 -0700
Message-ID: <1286314903.2156.54.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 14:36 -0700, Rhyland Klein wrote:
> > -----Original Message-----
> > From: Joe Perches [mailto:joe@perches.com]
> > > diff --git a/drivers/staging/iio/light/isl29018.c
> > b/drivers/staging/iio/light/isl29018.c
> > > +static int isl29018_chip_init(struct i2c_client *client)
> > > +{
> > > +	struct isl29018_chip *chip = i2c_get_clientdata(client);
> > > +	int status;
> > > +	int i;
> > > +	int new_adc_bit;
> > > +	unsigned int new_range;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(chip->reg_cache); i++)
> > > +		chip->reg_cache[i] = 0;
> > memset?
> I could use memset, except this is only 4 registers = 32 bytes,
> so I don't think that is really worth it do you?

Your choice.  I don't care really.  I didn't look to
see how many elements were in chip->reg_cache.

I just noted it as whenever I see a loop initialization
like that, I think memset not loop.

cheers, Joe

