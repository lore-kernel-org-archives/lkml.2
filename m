Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab2GCL6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:58:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59166 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab2GCL6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:58:50 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: enable module build for lp872x driver
Thread-Topic: [PATCH] regulator: enable module build for lp872x driver
Thread-Index: Ac1Yuc6q72LFCC6IR025YHgmWoxgJAAAijwAABV3TLA=
Date: Tue, 3 Jul 2012 11:58:43 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FCD6E@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FCCCF@DQHE02.ent.ti.com>
 <20120703093419.GB29030@opensource.wolfsonmicro.com>
In-Reply-To: <20120703093419.GB29030@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.108.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Tue, Jul 03, 2012 at 01:18:53AM +0000, Kim, Milo wrote:
> >
> > Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> 
> No, this won't build.  As we went through when we had to fix that only
> the other week...

Oh, sorry for bothering you again.
Please correct me if I miss something.
My understanding is boolean bulid configuration is temporary because the devm_gpio_request_one() is not exported.
But this gpio function had been patched in the linux-next tree and now we can use it in the module.
So that's why I've sent this patch again.

Thanks & BR
Milo -
