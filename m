Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1DZJB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:01:29 -0400
Received: from mhqmail.moxa.com ([59.124.42.180]:37984 "EHLO
	mhqmail01.moxa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714Ab1DZJB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:01:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] misc: add real function open/read/write/ioctl/close for moxa_serial_io driver
Date: Tue, 26 Apr 2011 17:01:23 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115F6A7D@mhqms01.moxa.com>
In-Reply-To: <20110425141354.GA28457@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] misc: add real function open/read/write/ioctl/close for moxa_serial_io driver
Thread-Index: AcwDUxc2F6cfHk2pSZqGNd/3A7b8GwAZKF4g
From: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Joe Perches" <joe@perches.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Greg KH" <gregkh@suse.de>
X-OriginalArrivalTime: 26 Apr 2011 09:01:23.0993 (UTC) FILETIME=[84ADF890:01CC03F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
	Thank for the advices. Yes, we think of accessing the I/O in user space level (http://www.faqs.org/docs/Linux-mini/IO-Port-Programming.html#s1). However, the driver has been used for many years in our product including ARM9/ARM11 series platform (note that #ifdef code have been removed in this patch). That the reason why we expect to remain the consistency during user access. Also, the driver will be used to support different arch in the future.

Alan,
	I agree the functionality of moxa_serial_io driver is not serial driver, that why I locate the driver in misc subsystem. I'm not sure whether patching to current driver mxser/moxa/8250 in tty subsystem to support switching mode could be a good idea because different hardware approach could be used by different vendor to support switching mode.

Let me know your consideration and I will send patch 2/2 again according to Alan advice about the out_p function. Thank.

//Jimmy.Chen
