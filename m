Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1FIIEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:04:40 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:44262 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab1FIIDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:03:06 -0400
X-AuditID: 83cfa826-b7c5dae0000046d4-17-4df07e38fb38
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <keithp@keithp.com>, <padovan@profusion.mobi>
CC: <marcel@holtmann.org>, <linux-bluetooth@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 9 Jun 2011 11:02:51 +0300
Subject: RE: Regression caused by "Bluetooth: Map sec_level to link key
 requirements"
Thread-Topic: Regression caused by "Bluetooth: Map sec_level to link key
 requirements"
Thread-Index: AcwmdcuZTkZgwxL5TPOpu86NujjU4gABYRnQ
Message-ID: <99B09243E1A5DA4898CDD8B700111448175AA2DB3B@EXMB04.eu.tieto.com>
References: <yunboy7a2so.fsf@aiko.keithp.com>
In-Reply-To: <yunboy7a2so.fsf@aiko.keithp.com>
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

 
>Patch 13d39315c22b128f4796fc008b04914a7c32bb1a is causing a 
>regression From 2.6.39. I cannot communicate with my Nokia 
>N900 using either the SyncML or DUN RFCOMM services.  I get a 
>connection reset error shortly after startup.
>
>I've reverted this patch on top of something past -rc2 (to be 
>precise, I'm branching from ef2398019b305827ea7130ebaf7bf521b444530e).
>With the following fix-up to make things build again, my 
>bluetooth works again.
>

hcidump -Rt > foo.log  from your test session will help as well


Waldek

