Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1HVXon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:44:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14774 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1HVXok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:44:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 22 Aug 2011 16:44:27 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Date: Mon, 22 Aug 2011 16:44:15 -0700
Subject: RE: [PATCH v2 1/4] gpio/tegra: Remove use of irq_to_gpio
Thread-Topic: [PATCH v2 1/4] gpio/tegra: Remove use of irq_to_gpio
Thread-Index: AcxYaNHJQ6Q3zVwcRIGQVSWeVwomXwAn8VZgAgchWXA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A377B@HQMAIL01.nvidia.com>
References: <1313095404-27858-1-git-send-email-swarren@nvidia.com>
 <CAMbhsRRGDAmYv3_EbJ+WVg0C7e3-FFcLCgq4W325ECKX06M6Hg@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24E3D@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24E3D@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Friday, August 12, 2011 10:07 AM:
> Colin Cross wrote at Thursday, August 11, 2011 2:54 PM:
> > On Thu, Aug 11, 2011 at 1:43 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > > irq_to_gpio is being removed. Replace the only use of that API by
> > > the ARM Tegra sub-architecture.
> > >
> > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > > ---
> > > This series is the irq_to_gpio patches I posted last week, rebased to ToT,
> > > plus removing Tegra's custom gpio_to_irq.
> > >
> > > This series was tested against next-20110811 on Harmony, by playing audio
> > > and plugging/unplugging headphones. Headphone detection relies on using a
> > > GPIO as an IRQ, and hence on gpio_to_irq.
> >
> > This whole series looks good to me:
> > Acked-by: Colin Cross <ccross@android.com>
> 
> Grant, Does this series look OK to you? Russell asked me to add it to the
> ARM patch system once you'd Ack'd it.
> 
> Thanks.

Russell, I've uploaded these to the ARM patch system as 7052..7055.

Note that I didn't wait for Grant's Ack, since Colin Ack'd them, and
Grant said in another thread that he's being very liberal in allowing
GPIO rework changes; I hope this is OK!

-- 
nvpublic

