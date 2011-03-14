Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1CNQPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:15:25 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:43291 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab1CNQPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:15:24 -0400
X-AuditID: 83cfa826-b7c18ae00000543e-d9-4d7e3f1af42d
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <arnd@arndb.de>
CC: <matti.j.aaltonen@nokia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>
Date: Mon, 14 Mar 2011 18:15:15 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcviYPBwbzsoWfnyQW62or2xROjbzAAAGJFg
Message-ID: <99B09243E1A5DA4898CDD8B7001114481082FAE168@EXMB04.eu.tieto.com>
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <201103141634.10865.arnd@arndb.de>
 <99B09243E1A5DA4898CDD8B7001114481082FAE15A@EXMB04.eu.tieto.com>
 <201103141700.26457.arnd@arndb.de>
In-Reply-To: <201103141700.26457.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> No, it's simply there as I have been faceing i2c write error while I 
>> do two consecutive writes.
>> The second fails now and then. That's seems to be a chip issue.
>> I will try to investigate this issue.
>
>Ok. It sounds like a bug in the i2c driver, you should also 
>take a look there. Maybe it has never had to deal with this 
>much write data at once.

It's been confirmed now that this is how chip is supposed to work and the driver should not care about this scenario. Upper layers (onfc stack) handle this.
Thus, will simply remove urange_sleep and that's it.

/Waldek



