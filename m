Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2C1Fsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 01:48:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36159 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2C1Fsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 01:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120327215838.AB7C33E13A0@localhost>
References: <1332769480-28069-1-git-send-email-shubhrajyoti@ti.com>
	<20120327215838.AB7C33E13A0@localhost>
Date: Wed, 28 Mar 2012 11:18:35 +0530
Message-ID: <CAM=Q2css7YLqgo4fsLPoPLi2rPkpS56-RXchM1dXWOe0Td2ieQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] spi: omap2-mcspi: driver updates
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net,
        Shubhrajyoti@ponder.secretlab.ca, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Wed, Mar 28, 2012 at 3:28 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, 26 Mar 2012 19:14:35 +0530, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
>> The patch series does the following cleanups
>> - Converts the spi to module_platform_driver
>> - Use the devm functions so that the freeing need not
>>   be done in the driver.
>> - Makes the driver use autosuspend
>> - Folds Benoit's bus_num removal patch in the series
>>
>> Changes from the previous version
>> - Makes the driver use autosuspend
>> - Folds Benoit's bus_num removal patch in the series
>>
>>
>> This is also available through
>> git     : git://gitorious.org/linus-tree/linus-tree.git
>> branch  : spi
>
> Hi Shubhrajyoti,
>
> I'll queue these ones up for v3.5 unless you make the argument that
> they are bug fixes that must go into v3.4.

No  thats fine if targeted for v3.5 .
Thanks,

>
> g.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
