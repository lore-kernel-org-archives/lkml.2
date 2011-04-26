Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1DZPlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:41:31 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:22391 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1DZPl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:41:29 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Tue, 26 Apr 2011 16:41:25 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcwEGeemItpdfNi4S7eUtGtw64CJCQADBdxQ
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
References: <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com> <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
In-Reply-To: <20110426135027.GI878@htj.dyndns.org>
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

Tejun wrote:
> Does the following patch resolve the problem?
>
> Thanks.

I have applied that patch, keeping Mark's mv_set_main_irq_mask spinlock patch
in place.  I would not like to commit absolutely, for obvious reasons, but I
have abused the port considerably and have not been able to coax it into
locking up.


Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
