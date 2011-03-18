Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1CRPPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:15:47 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:43015 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1CRPPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:15:41 -0400
X-AuditID: 83cfa826-b7c1cae000000efa-87-4d83771cc2dc
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <alan@lxorguk.ukuu.org.uk>
CC: <linux-i2c@vger.kernel.org>, <arnd@arndb.de>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>,
        <matti.j.aaltonen@nokia.com>
Date: Fri, 18 Mar 2011 17:15:30 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcvlftxyhnXDix60Qrqz68TfSp5FjQAACIPQ
Message-ID: <99B09243E1A5DA4898CDD8B7001114481085881971@EXMB04.eu.tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<20110318110348.728f6036@lxorguk.ukuu.org.uk>
	<99B09243E1A5DA4898CDD8B7001114481085881963@EXMB04.eu.tieto.com>
 <20110318151219.7aedc765@lxorguk.ukuu.org.uk>
In-Reply-To: <20110318151219.7aedc765@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAhesvxcXrL/D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I was thinking clear_bit/test_and_set_bit rather than atomic_t 
>operations.
>

I see, then I will for it.


Waldek