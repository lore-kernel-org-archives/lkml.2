Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1D0Nh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:37:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55580 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab1D0Nh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:37:27 -0400
Message-ID: <FED5DF6465AF41C58DBD4E0EEB200E60@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com> <201104271516.30951.arnd@arndb.de>
In-Reply-To: <201104271516.30951.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Wed, 27 Apr 2011 19:08:03 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PRU's resulting in improved load sharing.
>>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
>
> Hi Subhasish,
>
> This looks like great progress since the last time I looked at the
> pruss mfd driver, good work there!
>
> Thanks to your explanations and the documentation link, I now have
> a better understanding of what is actually going on here, but I'd
> still like to understandhow the decision is made regarding what programs
> are loaded into each PRU and how the MFD cells are set up.

>
> Is this a fixed setting for each board that strictly depends on how
> the external pins are connected, or is it possible to use the same
> hardware for different purposes based on the program?

SG  -- The PRU pins are exposed as is on the main board,
            we have separate add on daughter cards
            specific to the protocol implemented on it.

>
> If I read your code correctly, you hardwire the usage of the two
> PRUs in the da850 board code, which makes it impossible to use
> them in different ways even if the hardware supports it. If this is
> indeed the case, using an MFD device might not be the best option
> and we should try to come up with a way to dynamically repurpose
> the PRU with some user interface.

SG -- It depends upon how the firmware is implemented. If another
            firmware is downloaded on it, it will emulate another device.
            Also, if a firmware emulated on it supports switching between 
devices,
            that too is possible. Its just a microcontroller, we can do 
whatever we feel like
            with it. Both the PRUs have separate instruction/data ram, so 
both can be used
            to implement two different devices.
 

