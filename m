Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2A0JJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:09:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40526 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab2A0JJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:09:52 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Thread-Topic: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Thread-Index: AQHM3Efdz4WGVcb5lUWhYfrRza69QJYep98AgAFD8JA=
Date: Fri, 27 Jan 2012 09:09:33 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433179202C@DBDE01.ent.ti.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
 <1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
 <20120126191134.GA23484@sirena.org.uk>
In-Reply-To: <20120126191134.GA23484@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 00:41:34, Mark Brown wrote:
> On Thu, Jan 26, 2012 at 06:22:03PM +0200, Peter De Schrijver wrote:
> > CPUidle driver for tegra. In this version only LP3 (clockgating) is supported.
> 
> Are you aware of the work Rob Lee is doing on providing a common library
> for the ARM generic bits of cpuidle?  I really must convert the s3c64xx
> work I did on that over some time...

Slightly off-topic..

This is probably a bit early to ask but when it that likely to get merged?
I am working on cpuidle for AM33xx and if Rob's cpuidle consolidation is getting
merged soon I will try to use them in my baseline.
