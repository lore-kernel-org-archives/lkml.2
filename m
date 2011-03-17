Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1CQM6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:58:54 -0400
Received: from ebb05.tieto.com ([131.207.168.36]:46893 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab1CQM6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:58:48 -0400
X-AuditID: 83cfa824-b7b21ae000000a96-ed-4d820586e43b
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <arnd@arndb.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 17 Mar 2011 14:58:38 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcvfPyS7ttnLRyGCRXa8QB+sRnxvzQFY2NiQ
Message-ID: <99B09243E1A5DA4898CDD8B70011144810830AB119@EXMB04.eu.tieto.com>
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <201103101452.54862.arnd@arndb.de>
 <99B09243E1A5DA4898CDD8B7001114481082EF2A65@EXMB04.eu.tieto.com>
 <201103101720.53782.arnd@arndb.de>
In-Reply-To: <201103101720.53782.arnd@arndb.de>
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

Hi Arnd,

>> >Note that the microread_is_busy() logic does not protect you from 
>> >having multiple concurrent readers, because multiple threads may 
>> >share a single file descriptor.
>> 
>> It's just used to ensure that only one reader can open the device.
>> It's called only in open callback.
>> The mutex actually secures concurrent read operations. 
>
>So if having multiple readers is safe (though possibly not 
>meaningful), I guess you don't really need the 
>microread_is_busy() logic.
>
>I suppose it doesn't hurt either, it just seems a bit 
>pointless when it does the right thing most of the time, but 
>not always.
>

Could you give me an example when the microread_is_busy() logic does not do what it's intended to do.
I don't really get your point here. 


Waldek
