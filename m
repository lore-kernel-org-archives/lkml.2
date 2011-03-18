Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1CRPI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:08:57 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:54043 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823Ab1CRPIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:08:52 -0400
X-AuditID: 83cfa826-b7c1cae000000efa-25-4d837582540d
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, <arnd@arndb.de>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>,
        <matti.j.aaltonen@nokia.com>
Date: Fri, 18 Mar 2011 17:08:39 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcvlYo07sHRAHrVFSWK40CpwkSneHgAGqR5A
Message-ID: <99B09243E1A5DA4898CDD8B700111448108588196C@EXMB04.eu.tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110318114931.GA2155@pengutronix.de>
In-Reply-To: <20110318114931.GA2155@pengutronix.de>
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

Wolfram,

>> +	unsigned int irq_gpio;
>> +	unsigned int ioh_gpio;
>
>... you should request and setup the GPIOs before using them.

I assume the board specific code will do so. 


Waldek