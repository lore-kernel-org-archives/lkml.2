Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1FUSY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:24:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44438 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1FUSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049D2EB8AD@HQMAIL01.nvidia.com>
References: <20110621002318.8086.48367.stgit@riker> <74CDBE0F657A3D45AFBB94109FB122FF049D2EB8AD@HQMAIL01.nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 21 Jun 2011 12:24:05 -0600
X-Google-Sender-Auth: uYfNIRRpH4oRLF6xBMVAHR8SVwA
Message-ID: <BANLkTinUkAL_JwOhSSx5o9QYVH9G_B=5sw@mail.gmail.com>
Subject: Re: [PATCH] ARM: Tegra: i2c driver
To: Stephen Warren <swarren@nvidia.com>
Cc: John Bonesio <bones@secretlab.ca>, Ken Radtke <kradtke@nvidia.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 11:27 AM, Stephen Warren <swarren@nvidia.com> wrote:
> John Bonesio wrote at Monday, June 20, 2011 6:23 PM:
>> This patch modifies the tegra i2c driver so that it can be initiailized
>> using the device tree along with the devices connected to the i2c bus.
>
> The patch title "ARM: Tegra: i2c driver" doesn't really describe what the
> patch does and has the wrong tag; It sounds like adding a new driver.
> Perhaps "i2c: Tegra: Add DeviceTree support"?

Yes, sounds appropriate to me.

g.

>
> The code looks fine.
>
> --
> nvpublic
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
