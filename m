Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1CRQnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:43:42 -0400
Received: from ebb05.tieto.com ([131.207.168.36]:45752 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab1CRQng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:43:36 -0400
X-AuditID: 83cfa824-b7b21ae000000a96-bf-4d838bb64398
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, <arnd@arndb.de>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>,
        <matti.j.aaltonen@nokia.com>
Date: Fri, 18 Mar 2011 18:43:24 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcvlYo07sHRAHrVFSWK40CpwkSneHgAKHD4Q
Message-ID: <99B09243E1A5DA4898CDD8B70011144810858819A7@EXMB04.eu.tieto.com>
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

>> +free_irq:
>> +	free_irq(client->irq, info);
>> +free_buf:
>> +	kfree(info->buf);
>> +free_info:
>> +	kfree(info);
>> +
>> +	dev_info(&client->dev, "Not probed.");
>> +	return ret;
>> +}
>
>When respinning, you could consider using managed devices 
>(devm_*); this error path could completely go then.

Well, to be honest I did't know about that 'feature' :), but now I see it's pretty nice. Will start to use it.

Thanks,
Waldek

