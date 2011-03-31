Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1CaOmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:42:47 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:46670 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466Ab1CaOmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:42:45 -0400
X-AuditID: 83cfa826-b7c9dae000006cef-cc-4d9492e398ce
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <sameo@linux.intel.com>, <arnd@arndb.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hthebaud@insidefr.com>, <matti.j.aaltonen@nokia.com>,
        <alan@lxorguk.ukuu.org.uk>, <Sebastian.Chlad@tieto.com>
Date: Thu, 31 Mar 2011 17:42:21 +0300
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcvvrkuG1Wg3nf/2RAWa1PcyuYTJiwAAUMbg
Message-ID: <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110325142648.GC3879@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
 <201103291305.02293.arnd@arndb.de> <20110331141650.GB2704@sortiz-mobl>
In-Reply-To: <20110331141650.GB2704@sortiz-mobl>
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

>My idea of an initial NFC subsystem architecture was actually 
>the following
>one:
>- A core NFC layer against which NFC drivers would register.
>- A netlink socket for handling the HCI commands. That would 
>put a big part of the NFC HCI layer in kernel land and could 
>potentially simplify the existing NFC stacks.

Shouldn't be better to add a new AF_NFC sock family and then register new LLCP and HCI protocols?

Waldek