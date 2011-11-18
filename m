Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1KRVir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:38:47 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10184 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1KRVip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:38:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 18 Nov 2011 13:38:28 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 18 Nov 2011 13:38:27 -0800
Subject: RE: [PATCH 03/10] arm/tegra: prepare clock code for multiple tegra
 variants
Thread-Topic: [PATCH 03/10] arm/tegra: prepare clock code for multiple tegra
 variants
Thread-Index: AcymOIisZ4PiS4s0TXKfQFyJ3te0+AAAYy0Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74F95@HQMAIL01.nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
	<1321546766-26770-4-git-send-email-pdeschrijver@nvidia.com>
	<20111118190649.GB31678@quad.lixom.net>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74F48@HQMAIL01.nvidia.com>
 <CAOesGMix=CG5s8Ux_fiLKmSqdoVJgm5skm2MBrHg3YrNCyHaUg@mail.gmail.com>
In-Reply-To: <CAOesGMix=CG5s8Ux_fiLKmSqdoVJgm5skm2MBrHg3YrNCyHaUg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote at Friday, November 18, 2011 2:25 PM:
> On Fri, Nov 18, 2011 at 12:18 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Olof Johansson wrote at Friday, November 18, 2011 12:07 PM:
> >> On Thu, Nov 17, 2011 at 06:19:17PM +0200, Peter De Schrijver wrote:
...
> >> >  void tegra_sdmmc_tap_delay(struct clk *c, int delay)
...
> > I vote just rip this function out altogether.
> >
> > It isn't used in mainline, chromeos-2.6.38, chromeos-3.0, nor our internal
> > 2.6.36 or 2.6.39 kernels.
...
> 
> Actually, it used on some of the chromeos platforms, in particular for...

Oh yes, you're right. I'd grep'd for tegra2_sdmmc_tap_delay instead of
tegra_sdmmc_tap_delay, and saw hits in the clock code so didn't figure I'd
grep'd for the wrong thing.

-- 
nvpublic

