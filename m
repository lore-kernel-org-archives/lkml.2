Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1COIhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:37:18 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:46685 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab1COIhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:37:13 -0400
X-AuditID: 83cfa826-b7c18ae00000543e-be-4d7f253705a9
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <arnd@arndb.de>
CC: <matti.j.aaltonen@nokia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>
Date: Tue, 15 Mar 2011 10:37:04 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcviaWmRl48sU3z9SRWB+UM97oXn1gAgnTlA
Message-ID: <99B09243E1A5DA4898CDD8B7001114481082FAE39E@EXMB04.eu.tieto.com>
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <201103141700.26457.arnd@arndb.de>
 <99B09243E1A5DA4898CDD8B7001114481082FAE168@EXMB04.eu.tieto.com>
 <201103141801.01333.arnd@arndb.de>
In-Reply-To: <201103141801.01333.arnd@arndb.de>
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

>It sounds strange that this will be handled in user space, 
>since it won't have any idea if the hardware is available again.

>I've tried to find the onfc stack that talks to this device 
>but couldn't see it. Do you have a URL for this?

Here you are

http://sourceforge.net/projects/open-nfc/
http://www.open-nfc.org

Waldek