Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab1CaPZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:25:16 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:53705 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239Ab1CaPZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:25:14 -0400
X-AuditID: 83cfa826-b7c9dae000006cef-a1-4d949cd814d4
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <sameo@linux.intel.com>
CC: <arnd@arndb.de>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>,
        <matti.j.aaltonen@nokia.com>, <alan@lxorguk.ukuu.org.uk>,
        <Sebastian.Chlad@tieto.com>
Date: Thu, 31 Mar 2011 18:24:50 +0300
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: Acvvtatsmb3B/9MyQ3CkXgLwe/HTPAAACoPg
Message-ID: <99B09243E1A5DA4898CDD8B7001114481085F0FE7C@EXMB04.eu.tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110325142648.GC3879@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
 <201103291305.02293.arnd@arndb.de> <20110331141650.GB2704@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
 <20110331150939.GC2704@sortiz-mobl>
In-Reply-To: <20110331150939.GC2704@sortiz-mobl>
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

Hi Samuel,

>That's the Bluetooth approach, and it works just fine as well.
>However, the netlink option for sending commands and receiving 
>answers to/from a subsystem sounds more appropriate, at least to me.

I haven't used netlink in practice, so just wondering why netlink. I assume, then, it's more suitable :)

Waldek