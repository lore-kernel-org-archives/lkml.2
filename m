Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2ABMIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:08:10 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12734 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2ABMII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:08:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jan 2012 04:08:07 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 2 Jan 2012 17:37:04 +0530
Subject: RE: [PATCH V1] regulator: Enable supply regulator if child rail is
 enabled.
Thread-Topic: [PATCH V1] regulator: Enable supply regulator if child rail is
 enabled.
Thread-Index: AczJQs9xpDff5lCaSN283Np7cRoWxAAA62HA
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9A78@BGMAIL01.nvidia.com>
References: <1325489925-5148-1-git-send-email-ldewangan@nvidia.com>
 <20120102113623.GC2899@opensource.wolfsonmicro.com>
In-Reply-To: <20120102113623.GC2899@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Monday, January 02, 2012 5:06 PM
> > During regulator_register, the rail is set on the provided
> > machine constraints and if it is enabled then it is also
> > require to enable the supply regulator. This will make sure
> > that:
> >    1. Proper reference count for supply regulator to be maintain.
> >    2. Supply regulator should be enable when given rail is enabled.
> >
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> 
> Applied, thanks.
> 
> > When given rail is registered and if it has machine constratins to
> > enable the rail then it is also require to enable the supply rail for
> > a given rail. This will make sure that given rail is enabled and
> > proper reference count is maintained for the supply rail to avoid
> > disable of supply rail even child rail is enabled.
> 
> Why is this not in the changelog?
I think this is in just different wording for explaining the change.
