Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2B2Wiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:38:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1081 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2B2Wit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:38:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 Feb 2012 14:38:35 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 14:38:16 -0800
Subject: RE: [PATCH v3 00/10] Add tegra30 support for secondary cores
Thread-Topic: [PATCH v3 00/10] Add tegra30 support for secondary cores
Thread-Index: Acz2+NW8/EUB2EZiR5atvw78J2PLzQAOclDQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF21F3@HQMAIL01.nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178FACB954@HQMAIL01.nvidia.com>
 <20120229154229.GL12917@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20120229154229.GL12917@tbergstrom-lnx.Nvidia.com>
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

Peter De Schrijver wrote at Wednesday, February 29, 2012 8:42 AM:
> On Wed, Feb 15, 2012 at 10:27:43PM +0100, Stephen Warren wrote:
> > Peter De Schrijver wrote at Thursday, February 09, 2012 4:48 PM:
> > > This patchset introduces support for secondary cores on tegra30. It also
> > > introduces some functions for the flowcontroller and adds basic support for
> > > tegra30 powerdomains.
> >
> > The code looks fine to me. I do notice the following when running
> > "shutdown -h now":
> >
> > [   27.762124] SMP: failed to stop secondary CPUs

I can't seem to reproduce this at all on next-20120229 anymore. What
kind of repro frequency are you seeing, and does it get fixed if you
update to that baseline?

(I tried 20 times with shutdown, and 15 of them I reverted all the CPU
and cache errata in case they affected the issue at all)

-- 
nvpublic

