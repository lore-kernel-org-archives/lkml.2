Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1C2IBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:01:21 -0400
Received: from ebb05.tieto.com ([131.207.168.36]:49809 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1C2IBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:01:20 -0400
X-AuditID: 83cfa824-b7c05ae0000063da-a6-4d9191ce8251
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <sameo@linux.intel.com>, <arnd@arndb.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hthebaud@insidefr.com>, <matti.j.aaltonen@nokia.com>,
        <alan@lxorguk.ukuu.org.uk>
Date: Tue, 29 Mar 2011 11:00:59 +0300
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: Acvq+LBFXfZeQmOsQeSYsQVhTbupEAC7jlrw
Message-ID: <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <201103181319.54191.arnd@arndb.de> <20110325142648.GC3879@sortiz-mobl>
In-Reply-To: <20110325142648.GC3879@sortiz-mobl>
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

>Yes, NFC seems to be a good fit for a new socket family. 
>Especially if we ever want to have a proper NFC p2p support 
>from the kernel.
>Sending HCI commands should be done through a dedicated 
>netlink socket too.
>
>I am currently strting to work on such solution, and I hope to 
>be able to come up with a basic prototype for it in a few weeks.

What about common drivers interface in this case.  Should we go for common /dev/nfcX interface as well?

Waldek