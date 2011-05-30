Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1E3OhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:37:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36936 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1E3OhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:37:07 -0400
Message-ID: <98F790F0AABD4248A3DBFF4BA7D926B1@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105231730.06564.arnd@arndb.de> <7E10264BABCB4C1788DCD9715461BDE8@subhasishg> <201105241440.34854.arnd@arndb.de> <20110524134338.GA13491@kroah.com> <45A0E7B350CB4DF685D18EFE6EB1CB76@subhasishg> <20110530140231.GA11831@kroah.com>
In-Reply-To: <20110530140231.GA11831@kroah.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Date: Mon, 30 May 2011 20:08:03 +0530
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

>> >
>> How do I handle the headers. I have two header files in the
>> include/linux/mfd.
> 
> Why would they be in there for a single driver?
> 
>> Should I submit them as a separate patch into mfd.
>> 
>> These headers are also used by pruss uart implementation.
> 
> Then put them in the staging directory for your driver, why would
> anything outside of your driver need a .h file?
> 
There are two header files in the include/linux/mfd/pruss.h & pruss_core.h

the file pruss.h is included by the pruss_suart_api.c (tty uart driver) for
some data structures, defines and function prototypes. 
