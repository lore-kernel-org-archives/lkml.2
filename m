Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab2IJOSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:18:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40376 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2IJOR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:17:57 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mtd:nand:clk: preparation for switch to common clock
 framework
Thread-Topic: [PATCH] mtd:nand:clk: preparation for switch to common clock
 framework
Thread-Index: AQHNhtupPgQfBcoi0EWgwLIMml+uo5d/xaiA//+zJYCAAINZgIADs/cQ
Date: Mon, 10 Sep 2012 14:17:47 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041B81C0@DFLE12.ent.ti.com>
References: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
	<20120907212853.20289.86031@nucleus>
	<3E54258959B69E4282D79E01AB1F32B7041B73E9@DFLE12.ent.ti.com>
 <CAN8TOE8tpyPK2V4=YQWP7bK7e5AqFDE27EBpKhn0hj-u6r3HAA@mail.gmail.com>
In-Reply-To: <CAN8TOE8tpyPK2V4=YQWP7bK7e5AqFDE27EBpKhn0hj-u6r3HAA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Brian Norris [mailto:computersforpeace@gmail.com]
>> Sent: Friday, September 07, 2012 8:44 PM
>> To: Karicheri, Muralidharan
>> Cc: Mike Turquette; dwmw2@infradead.org; artem.bityutskiy@linux.intel.com;
>> dbaryshkov@gmail.com; linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] mtd:nand:clk: preparation for switch to common clock framework
>> 
>> On Fri, Sep 7, 2012 at 2:56 PM, Karicheri, Muralidharan
>> <m-karicheri2@ti.com> wrote:
>> > How do these patch get to upstream? Does this get merged through davinci maintainer
>> or through individual subsystem maintainers?
>> 
>> I think this driver would be taken by David Woodhouse in his linux-mtd
>> repo. Usually Artem Bityutskiy gleans the mailing list of patches and
>> puts them in his l2-mtd-2.6 git repo to help David out. Give it some
>> time, and I'm sure they'll be taking it. We don't really have a
>> full-time maintainer!
>> 
>> Brian

Thanks Brian for your response. Understood. Will wait.

Murali Karicheri
Software Design Engineer

