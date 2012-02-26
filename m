Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2BZWpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 17:45:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50287 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BZWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 17:45:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.195.99 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F4AB61C.4080404@gmail.com>
Date: Mon, 27 Feb 2012 09:45:48 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de
Subject: Re: [PATCH v3 17/21] ARM: at91: merge SRAM Memory banks thanks to
 mirroring
References: <cover.1330006537.git.nicolas.ferre@atmel.com> <c9b1e3ffbc322a1d1e1272062a9361abe536a33a.1330006537.git.nicolas.ferre@atmel.com> <4F46B3DF.7010402@gmail.com> <20120224165443.GA21556@game.jcrosoft.org>
In-Reply-To: <20120224165443.GA21556@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/02/12 03:54, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 08:47 Fri 24 Feb     , Ryan Mallon wrote:
>> On 24/02/12 01:26, Nicolas Ferre wrote:
>>
>>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>>
>>> On at91sam9260 and at91sam9g20 the SRAM banks are mirrored. We can
>>> merge them together to be able to have bigger and continuous
>>> internal RAM.
>>
>> I think this patch needs some comments in the code. As mentioned in the
>> last round, this functionality is not documented, so it is not obvious
>> how/why this works. This is especially true for any user who has
>> problems with this code and then tries to look up those addresses in
>> their at91 manual only to find the regions are reserved.
>>
>> Nicolas, are you able to give an official Atmel stance on this?
> you have the ack from Nico and he send the e-mail

Sure, but it would be nice to get some official documentation on this.
Why was the feature, which seems quite useful, never documented? Is it
supported on all revisions of the chips? Are there any restrictions or
caveats to using the mirrored layout versus the separate layout?

At the very least, the code needs to be documented, since anyone using
this code is not able to look up the details in the at91 technical manuals.

~Ryan
