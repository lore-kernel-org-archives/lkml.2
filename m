Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1D1L6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:58:50 -0400
Received: from smtp.nokia.com ([147.243.1.48]:17785 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1D1L6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:58:48 -0400
From: <kalle.jokiniemi@nokia.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <lrg@slimlogic.co.uk>, <mchehab@infradead.org>, <svarbatov@mm-sol.com>,
        <saaguirre@ti.com>, <grosikopulos@mm-sol.com>,
        <vimarsh.zutshi@nokia.com>, <Sakari.Ailus@nokia.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: RE: [RFC] Regulator state after regulator_get
Thread-Topic: [RFC] Regulator state after regulator_get
Thread-Index: AQHMBYvuahnBNc70lUOziC4VKJ5gv5RzHHpw///h3wCAACaloA==
Date: Thu, 28 Apr 2011 11:58:26 +0000
Message-ID: <9D0D31AA57AAF5499AFDC63D6472631B09C8CE@008-AM1MPN1-036.mgdnok.nokia.com>
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
 <20110428100629.GA14494@opensource.wolfsonmicro.com>
 <9D0D31AA57AAF5499AFDC63D6472631B09C858@008-AM1MPN1-036.mgdnok.nokia.com>
 <20110428111447.GA19484@opensource.wolfsonmicro.com>
In-Reply-To: <20110428111447.GA19484@opensource.wolfsonmicro.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.212.101]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Apr 2011 11:58:28.0201 (UTC) FILETIME=[9606F590:01CC059B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 > -----Original Message-----
 > From: ext Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
 > Sent: 28. huhtikuuta 2011 14:15
 > To: Jokiniemi Kalle (Nokia-SD/Tampere)
 > Cc: lrg@slimlogic.co.uk; mchehab@infradead.org; svarbatov@mm-sol.com;
 > saaguirre@ti.com; grosikopulos@mm-sol.com; Zutshi Vimarsh (Nokia-
 > SD/Helsinki); Ailus Sakari (Nokia-SD/Helsinki); linux-kernel@vger.kernel.org;
 > linux-media@vger.kernel.org
 > Subject: Re: [RFC] Regulator state after regulator_get
 > 
 > On Thu, Apr 28, 2011 at 11:08:08AM +0000, kalle.jokiniemi@nokia.com wrote:
 > 
 > > I don't have a full set of regulators described, that's why things broke when
 > > I tried the regulator_full_constraints call earlier. But I don't think it would be
 > too
 > > big issue to check the current after boot configuration and define all the
 > > regulators as you suggest. I will try this approach.
 > 
 > As I said in my previous mail if you've got a reagulator you don't know
 > about which is on you can give it an always_on constraint until you
 > figure out what (if anything) should be controlling it.

Yeps, I plan to check the PMIC for the regulators that are left on after boot
In the current working setup and then put those "always_on" flags on those
regulators in the final setup.

Thanks for the help!

- Kalle
