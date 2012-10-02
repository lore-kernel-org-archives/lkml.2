Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2JBMzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:55:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:65270 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab2JBMzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:55:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="228981535"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: anish kumar <anish198519851985@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: How to schedule worker and threaded IRQ on same cpu/core
Thread-Topic: How to schedule worker and threaded IRQ on same cpu/core
Thread-Index: Ac2gmCa8Mz8HGOSiRo6E8/HEDKZlVv//qPCA//+gawA=
Date: Tue, 2 Oct 2012 12:54:55 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD2A1EE5@BGSMSX102.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD2A1E0A@BGSMSX102.gar.corp.intel.com>
 <1349181465.1440.1.camel@anish-Inspiron-N5050>
In-Reply-To: <1349181465.1440.1.camel@anish-Inspiron-N5050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q92CtATD031862

> > How can I schedule driver's worker and threaded IRQ on the same core?
> >
> > For work queue we have schedule_delayed_work_on () API available.
> > But how to schedule the threaded IRQ on the same core where my worker
> thread is going to run?
> Why do you need to worry about where your worker thread is going to run?
> Or IOW what use case do you have in mind?

In my driver I can get two independent events(IRQ and kernel notification). One will be handled by
Threaded IRQ and other will be handled by a worker and the order is not guaranteed and with two cores
Sometimes both workers are being scheduled  parallel.

The events I get from two sources are related so I wanted to run my workers and threaded IRQ on single(same) core/cpu.

Thanks,
Ram
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
