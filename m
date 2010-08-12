Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab0HLKdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:33:50 -0400
Received: from ns.omicron.at ([212.183.10.25]:53851 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759748Ab0HLKdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:33:49 -0400
X-Greylist: delayed 2762 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Aug 2010 06:33:47 EDT
From: Richard Cochran <richard.cochran@omicron.at>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Robert Schwebel <r.schwebel@pengutronix.de>
CC: "meego-dev@meego.com" <meego-dev@meego.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "qi.wang@intel.com" <qi.wang@intel.com>,
        "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "andrew.chih.howe.khor@intel.com" <andrew.chih.howe.khor@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>
Date: Thu, 12 Aug 2010 11:43:26 +0200
Subject: RE: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to2.6.35
Thread-Topic: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver
 to2.6.35
Thread-Index: Acs5QkTivyEwyJVdTSyPcG3Tl7JSsQAwIsB7
Message-ID: <95DC1AA8EC908B48939B72CF375AA5E3F00A1BB0@alice.at.omicron.at>
References: <4C612AA4.5040100@dsn.okisemi.com>
 <20100811090809.GH30096@pengutronix.de>,<000801cb3942$41d0f870$66f8800a@maildom.okisemi.com>
In-Reply-To: <000801cb3942$41d0f870$66f8800a@maildom.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My specified CC of IEEE1588 patch e-mail is not enough.
> I will re-submit the patch again.

Please post anything with PTP or hardware time stamping on net-next for review.

>> Are you aware of Richard Cochran's 1588 support patches? I'm not sure
>> about the integration status, but Richard (set on Cc:) can surely say
>> more.

The background work need for PHY time stamping has been accepted.

For the rest, I am preparing to post another patch set soon...

Thanks,
Richard
