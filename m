Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1HYKgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:36:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34631 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752615Ab1HYKgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:36:19 -0400
Date: Thu, 25 Aug 2011 11:36:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Colin Cross <ccross@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
Message-ID: <20110825103616.GC31154@opensource.wolfsonmicro.com>
References: <CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
 <20110806084805.GA18098@sirena.org.uk>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
 <CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
 <CAMbhsRTVm+dUODDgqiekpTrrNnpo9trJNNvOQ2ETCNkneh-L-g@mail.gmail.com>
 <1313109916.19990.28.camel@finisterre.wolfsonmicro.main>
 <CAMbhsRShLvyc2XKJAL8PwR0Uj4Pnp9rVt7QyK1qAVxJ-R2PSdQ@mail.gmail.com>
 <20110812031433.GE10218@opensource.wolfsonmicro.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04B24A3CA6@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B24A3CA6@HQMAIL01.nvidia.com>
X-Cookie: Never reveal your best argument.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:28:29PM -0700, Stephen Warren wrote:

> (and you'd mentioned having the subsystem maintainers weigh in on this;
> which sub-system; IRQ, power, I2C, ...?)

I'm one of the regulator API subsystem maintainers FWIW.
