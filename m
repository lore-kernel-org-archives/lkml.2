Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1CRVhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:37:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46947 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab1CRVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <201103182106.13888.arnd@arndb.de>
References: <20110311165642.GA9996@kroah.com> <201103181600.09877.arnd@arndb.de>
 <4D839BCD.6030202@linaro.org> <201103182106.13888.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 Mar 2011 15:36:36 -0600
X-Google-Sender-Auth: OeIzZRIc8aaCPKThlcz-fcT-Np8
Message-ID: <AANLkTinjMH4rvSaUaV0LhnWy1oF4xumTCLN=-srYmfdK@mail.gmail.com>
Subject: Re: RFC: Platform data for onboard USB assets
To: Arnd Bergmann <arnd@arndb.de>
Cc: andy.green@linaro.org, Greg KH <greg@kroah.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 2:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> No, that is not the plan. The platform data is well-established
> for deeply embedded systems (blackfin, arm-nommu, mips32, ...) where you
> never want to build a kernel for multiple boards anyway. We also
> have ways to generate platform_data from the device tree properties
> to allow the same driver to be used by systems with or without
> full device trees, and we have the fragments I mentioned that work
> in the opposite way.

Not actually true.  We have drivers that can use both platform_data
and device tree data, and for platform devices the resource table is
automatically populated with irqs and register ranges, but
platform_data is driver specific which prevents any automatic
translation.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
