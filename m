Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2KLQkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:40:53 -0500
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:5360 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2KLQkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:40:52 -0500
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [PATCH v5] staging: ste_rmi4: Convert to Type-B support
Thread-Topic: [PATCH v5] staging: ste_rmi4: Convert to Type-B support
Thread-Index: AQHNvq8+4gF6/ke0DkSMmVgIflkkQJfmYW14
Date: Mon, 12 Nov 2012 16:40:34 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F622A3@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121108150529.b16707c1c84e6fd862e58b6a@tw.synaptics.com>,<20121109192604.GA16972@polaris.bitmath.org>
In-Reply-To: <20121109192604.GA16972@polaris.bitmath.org>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.10.5]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

>> Convert to MT-B because Synaptics touch devices are capable
>> of tracking identifiable fingers.
>>
>> Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
>> ---
>> Changes from v5:
>>         - Incorporated Henrik's review comments
>>           *rollback to v3 from v4
>>           *fix odd line break in v3
>>         - Include Alexandra in the list of authors
>
> I am seeing _new_ irrelevant changes in this version... There is no
> need to revert to v3. Just remove the synaptics_rmi4_query_function()
> changes and other uneeded cruft from the v4 patch. No new changes,
> please, and make sure the final patch is tested.

Those changes are intended to fix line over 80 characters in v3.
The code has been optimized and the logic does not change.
Patch v5 has been verified with pandaboard.
Any suggestions are much appreciated.

Best regards,
Alexandra