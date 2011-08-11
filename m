Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1HKTgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:36:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14385 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1HKTgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:36:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 11 Aug 2011 12:35:43 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Colin Cross <ccross@google.com>
CC: Ben Dooks <ben-linux@fluff.org>, Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Aug 2011 12:35:36 -0700
Subject: RE: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Thread-Topic: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Thread-Index: AcxUFZKaoNPjzeLARHaid/4iXWUrGAESBDzw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
 <CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
 <20110806084805.GA18098@sirena.org.uk>
In-Reply-To: <20110806084805.GA18098@sirena.org.uk>
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

Mark Brown wrote at Saturday, August 06, 2011 2:48 AM:
> On Fri, Aug 05, 2011 at 09:33:31PM -0700, Colin Cross wrote:
...
> > NAK - moving the suspend order around is not the correct way to solve
> > this.  If wm8903 needs to talk to the i2c bus in its suspend handler,
> > it needs to be child device on the i2c bus.  suspend_noirq is for
>
> WM8903 is an I2C device.  The problem is that it's suspended as part of
> the ASoC suspend since the audio subsystem is composed of multiple
> devices that all need to work together coherently.  I did start doing
> some stuff to bodge around this like we do on probe but there are enough
> system wide problems with this that it didn't seem worth the complexity
> when the existing workarounds are so straightforward.

Colin, given Mark's explanation, are you OK with the patch now?

Thanks.

-- 
nvpublic

