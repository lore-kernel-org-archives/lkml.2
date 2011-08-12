Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1HLQH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:07:59 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19390 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1HLQH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:07:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 12 Aug 2011 09:07:39 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
CC: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Date: Fri, 12 Aug 2011 09:07:27 -0700
Subject: RE: [PATCH v2 1/4] gpio/tegra: Remove use of irq_to_gpio
Thread-Topic: [PATCH v2 1/4] gpio/tegra: Remove use of irq_to_gpio
Thread-Index: AcxYaNHJQ6Q3zVwcRIGQVSWeVwomXwAn8VZg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24E3D@HQMAIL01.nvidia.com>
References: <1313095404-27858-1-git-send-email-swarren@nvidia.com>
 <CAMbhsRRGDAmYv3_EbJ+WVg0C7e3-FFcLCgq4W325ECKX06M6Hg@mail.gmail.com>
In-Reply-To: <CAMbhsRRGDAmYv3_EbJ+WVg0C7e3-FFcLCgq4W325ECKX06M6Hg@mail.gmail.com>
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

Colin Cross wrote at Thursday, August 11, 2011 2:54 PM:
> On Thu, Aug 11, 2011 at 1:43 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > irq_to_gpio is being removed. Replace the only use of that API by
> > the ARM Tegra sub-architecture.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > This series is the irq_to_gpio patches I posted last week, rebased to ToT,
> > plus removing Tegra's custom gpio_to_irq.
> >
> > This series was tested against next-20110811 on Harmony, by playing audio
> > and plugging/unplugging headphones. Headphone detection relies on using a
> > GPIO as an IRQ, and hence on gpio_to_irq.
> 
> This whole series looks good to me:
> Acked-by: Colin Cross <ccross@android.com>

Grant, Does this series look OK to you? Russell asked me to add it to the
ARM patch system once you'd Ack'd it.

Thanks.

-- 
nvpublic

