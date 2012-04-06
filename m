Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2DFIoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:44:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52330 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2DFIoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:44:17 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Apr 2012 01:44:14 -0700
Subject: RE: Question about the regulator driver
Thread-Topic: Question about the regulator driver
Thread-Index: Ac0T0RoNiMplTf0LQlKBJaXyQxxuAQAADTpQ
Message-ID: <B567DBAB974C0544994013492B949F8E38135B6565@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E38135B639C@EXMAIL03.scwf.nsc.com>
 <20120406084140.GB3172@opensource.wolfsonmicro.com>
In-Reply-To: <20120406084140.GB3172@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your opinion.

Best Regards,
Milo -

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Friday, April 06, 2012 5:42 PM
> To: Kim, Milo
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Question about the regulator driver
> 
> On Thu, Apr 05, 2012 at 05:36:02PM -0700, Kim, Milo wrote:
> 
> > But charging termination voltage and charging current can be
> > configurable in the charger operation.
> > In that case, is it common to add regulator_ops for the charger ?
> > Or is it better that charging parameters are set only in the power
> > supply driver ?
> 
> I'd just do it as part of the power supply driver, these limits are
> internal to the charger driver and so there's no real value in
> exporting
> them.
