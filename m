Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1E3NYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:24:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54307 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1E3NYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:24:16 -0400
Message-ID: <45A0E7B350CB4DF685D18EFE6EB1CB76@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Greg KH" <greg@kroah.com>, "Arnd Bergmann" <arnd@arndb.de>
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105231730.06564.arnd@arndb.de> <7E10264BABCB4C1788DCD9715461BDE8@subhasishg> <201105241440.34854.arnd@arndb.de> <20110524134338.GA13491@kroah.com>
In-Reply-To: <20110524134338.GA13491@kroah.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Date: Mon, 30 May 2011 18:55:12 +0530
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

Greg,

> There really are only 3 rules:
> - proper license
> - self-contained in a drivers/staging/DRIVER_NAME/ directory
> - must properly build
> 
>> Mainly, this includes having a patch that adds a single
>> directory with all the driver files under drivers/staging.
>> The driver must be able to compile without errors and you need
>> a TODO file listing the remaining issues that prevent you
>> from having a non-staging driver.
> 
> Ah, forgot the TODO on the list of rules, I'll have to add that next
> time.
> 
How do I handle the headers. I have two header files in the
include/linux/mfd.

Should I submit them as a separate patch into mfd.

These headers are also used by pruss uart implementation. 
