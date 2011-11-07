Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1KGLHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:07:24 -0500
Received: from portal.weinmann.de ([62.8.140.122]:12397 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1KGLHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:07:23 -0500
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'balbi@ti.com'" <balbi@ti.com>
CC: "'linux-i2c@vger.kernel.org'" <'linux-i2c@vger.kernel.org'>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<'linux-arm-kernel@lists.infradead.org'>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'plagnioj@jcrosoft.com'" <plagnioj@jcrosoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>
Date: Mon, 7 Nov 2011 12:06:52 +0100
Subject: RE: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Thread-Topic: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Thread-Index: AcydNLYy45JamylDS0aTu+1BOHlkWAABlwkA
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B38B2AB@wm021.weinmann.com>
References: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
 <20111107094701.GF4265@legolas.emea.dhcp.ti.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B38B21C@wm021.weinmann.com>
 <20111107100446.GG4265@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111107100446.GG4265@legolas.emea.dhcp.ti.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > IMHO, you should split this patch into three or more smaller patches.
> > > You're doing lots of different things in one commit and it'll be a
> > > pain to bisect should this cause any issues to anyone.
> >
> > I didn't split the patch because it is virtually a complete rewrite.
> > Due to the severe limitations of the old driver, I think it should
> > replace the old driver.
> 
> The final decision is up to Ben and/or Jean but I think we should always have
> incremental patches, not sure if we should allow big patches for the reasons
> above.

Splitting the patch implies the possibility to test each incremental
change independently, a possibility I don't have with my current setup as
the old driver didn't work at all for me (for example, my client needs
repeated start). I developed and tested the driver in an all or nothing-at-all
approach. Splitting the patch would be a purely academic exercise for me,
without any extra value beyond readability (which is admittedly bad now).
>From that point of view, I should maybe submit the patch as a new independent
driver (although it is a logical replacement for the old one)?

Niko

