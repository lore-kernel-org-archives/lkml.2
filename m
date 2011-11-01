Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1KAICW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:02:22 -0400
Received: from portal.weinmann.de ([62.8.140.122]:12526 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1KAICS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:02:18 -0400
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: =?iso-8859-1?Q?=27H=E5vard_Skinnemoen=27?= <hskinnemoen@gmail.com>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Nov 2011 09:02:08 +0100
Subject: RE: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Topic: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Index: AcyYZE/mlvGDbQhsR7a2xIKWGvqqQgABwoQg
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B34BEE2@wm021.weinmann.com>
References: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
	<CAF8ieYXPMgUzekth7PGxC3AgYNKac-HQ21D3vvB5J3SLOatmfQ@mail.gmail.com>
	<EF2E73589CA71846A15D0B2CDF79505D087B34BE8B@wm021.weinmann.com>
 <CAF8ieYWY2RwkgPERgagvw2bby8Y+UFgrYr3zPOb27e=bfOH-vg@mail.gmail.com>
In-Reply-To: <CAF8ieYWY2RwkgPERgagvw2bby8Y+UFgrYr3zPOb27e=bfOH-vg@mail.gmail.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is never correct to use push-pull I/O for i2c, so the flag does not
> specify the desired behavior of the driver, it specifies what the
> hardware has been configured to do so that the driver can choose the
> cheapest way to do open-drain I/O.

Ok, seems rather logical after all.

> 
> And even if you could argue that the flag should be inverted, it has
> had the same meaning since the driver was introduced several years
> ago, so changing it now will break every single platform which
> currently uses i2c-gpio.

I completely agree.

Thanks for the explanation,
Niko

