Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2FSGmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:42:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37930 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2FSGmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:42:11 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: RE: [PATCH v2] regulator: add new regulator driver for lp872x
Thread-Topic: [PATCH v2] regulator: add new regulator driver for lp872x
Thread-Index: Ac1K013lgBKp+AGARUeXJs2xlf9z8P//oncAgAAIR4D/+YbK8A==
Date: Tue, 19 Jun 2012 06:42:05 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FB879@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
 <CAF+7xW=Cb3b64khdNsnyfkJiS4Yt+j8tGFQExAoddXrtu=+5=Q@mail.gmail.com>
 <20120615114125.GC4482@opensource.wolfsonmicro.com>
In-Reply-To: <20120615114125.GC4482@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, Jun 15, 2012 at 07:11:48PM +0800, Axel Lin wrote:
> 
> > > +       ret = gpio_request(gpio, "LP872X DVS");
> 
> > devm_gpio_request
> 
> Better yet...
> 
> > > +       gpio_direction_output(gpio, dvs->init_state);
> 
> ...devm_gpio_request_one().
> 

Thanks for the update.
In patch v3, devm_gpio_request_one() will be used in replacement of gpio_request() and gpio_direction_output().

Thanks & BR
Milo -

