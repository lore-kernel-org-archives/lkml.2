Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab1EYNg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:36:28 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:39746 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab1EYNgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:36:25 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Wed, 25 May 2011 14:36:20 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcwawRXG3oF7h9giTluT3tL547FYRgAHvs3A
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C7770967B@gretna.indigovision.com>
References: <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
 <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
 <20110430140109.GJ29280@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
 <20110525094127.GF10146@htj.dyndns.org>
In-Reply-To: <20110525094127.GF10146@htj.dyndns.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a different issue.  libata EH plugs the port if reset fails
> repeatedly.  This behavior was implemented to avoid causing continuous
> resets on a port in case it has flaky PHY state reporting; however, it
> seems to cause more trouble than fixing issues - ie. plugging in a
> broken device may end up plugging the port even after the offending
> device is removed until manual rescan or reboot.  I've been pondering
> about changing the behavior like the following.

Thanks for the explanation, Tejun, and for sending those changes upstream.
I shall incorporate these patches into my kernel and keep you informed as
to how they behave.

Mark, did you get a chance to clean up the sata_mv spinlock addition in
mv_set_main_irq_mask?

Many Thanks,

Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
