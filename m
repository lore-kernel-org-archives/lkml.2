Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1E3OMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:12:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51535 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1E3OMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:12:13 -0400
Message-ID: <2AF43CEDFDB649AE946E8F9F98A5AE48@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Greg KH" <greg@kroah.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <20110524134338.GA13491@kroah.com> <45A0E7B350CB4DF685D18EFE6EB1CB76@subhasishg> <201105301604.38026.arnd@arndb.de>
In-Reply-To: <201105301604.38026.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Date: Mon, 30 May 2011 19:43:07 +0530
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

> On Monday 30 May 2011, Subhasish Ghosh wrote:
>> > Ah, forgot the TODO on the list of rules, I'll have to add that next
>> > time.
>> >
>> How do I handle the headers. I have two header files in the
>> include/linux/mfd.
>>
>> Should I submit them as a separate patch into mfd.
>>
>> These headers are also used by pruss uart implementation.
>
> During the time when the drivers are in staging, all files need to
> be in the same directory, including the header and the drivers using it.
> They can get moved at the time when the driver gets turned into
> a regular non-staging driver.

OK, so the UART implementation needs to be moved into staging as well ?

And what about the boardfile changes, array of mfd_cells implementation etc. 

