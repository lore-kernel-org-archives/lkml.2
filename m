Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2ISV5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:57:53 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:25519 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2ISV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:57:50 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 19 Sep 2012 14:27:36 -0700
Message-ID: <505A3FDD.1050006@synaptics.com>
Date: Wed, 19 Sep 2012 14:57:49 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>
Subject: Re: [PATCH] Input: Add new driver into Input Subsystem for Synaptics
 DS4 touchscreen I2C devices
References: <CC51EC7B5B7F984AA566DC102237848896F57221@hkdcw-mail1.synaptics-inc.local> <CACRpkdah8jqHRVRiA35H8eSugPkWuAZES_0J+OmmBr2yR07nZw@mail.gmail.com>
In-Reply-To: <CACRpkdah8jqHRVRiA35H8eSugPkWuAZES_0J+OmmBr2yR07nZw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2012 03:33 PM, Linus Walleij wrote:
> On Sun, Sep 16, 2012 at 11:56 AM, Alexandra Chin
> <alexandra.chin@tw.synaptics.com> wrote:
>
>> Synaptics DS4 touchscreen driver implements a generic driver supporting I2C
>> protocol for Synaptics Design Studio 4 (DS4) family of Touchscreen Controllers
>> which include the following:
>>
>> - S32xX series
>> - S730X series
>> - S22xx series
>>
>> The driver supports multifinger pointing functionality and power management.
>> The driver is based on the original work submitted by
>> Linus Walleij <linus.walleij@stericsson.com> and
>> Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>.
>
> Naveen's driver is sitting in drivers/staging/ste_rmi4 right now because
> Christopher Heiny is working on a RMI4 bus driver, and wanted to
> merge that.
>
> I am happy with this being merged for now if the plan is
> to eventually replace it with Christopher's (et al) driver,
> if it's not going to disturb the other driver in the end.
>
> How are Synaptics planning to handle the transition?
> (I assume you are coordinated... not always the case in
> big companies, I know from experience :-)
>
> Remember to keep Henrik Rydberg in the loop on touch
> controllers.

Hi Linus,

The RMI4 bus driver will continue to be developed by my team, with the 
intent that it will support all RMI4 functions as well as all Synaptics 
RMI4 products, and the goal of eventual inclusion in the kernel. 
However, as you've noted elsewhere, this is taking a while. :-)

In the meantime, there is a perceived customer pull for a limited 
functionality product/platform specific "thin driver".  Alexandra's team 
has been working on such a driver, resulting in her patch submission 
from a couple of days ago.  They really would like to see both our 
drivers being adopted into the kernel. This will enable them to support 
all our customers effectively and provide our customers with the best 
flexibility possible. Going forward, Synaptics will continue to 
maintain, support and upgrade these drivers for future touch controller 
platforms as well.

						Chris
