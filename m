Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1COHVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:21:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55615 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1COHVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:21:46 -0400
Message-ID: <99FA4F65346D4615AC7C8CFEF72133E7@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "maintainer:TTY LAYER <gregkh@suse.de>, commit_signer:2/4=50%,
	commit_signer:1/2=50%" <Greg.Kroah-Hartman@rcsinet15.oracle.com>,
        "Andrew Morton \(commit_signer:1/4=25%\)" <akpm@linux-foundation.org>,
        "Randy Dunlap \(commit_signer:1/4=25%\)" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com><1299592667-21367-8-git-send-email-subhasish@mistralsolutions.com> <20110308104757.0f75409b.randy.dunlap@oracle.com>
In-Reply-To: <20110308104757.0f75409b.randy.dunlap@oracle.com>
Subject: Re: [PATCH v3 7/7] tty: add pruss SUART driver
Date: Tue, 15 Mar 2011 12:53:47 +0530
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

Hello,

Thank you for your comments.
Would really appreciate more comments and ways to fix this patch and bring 
it
up to Linux Standards.
If I have missed something/misunderstood then please let me know.


>> +config SERIAL_PRUSS_SUART
>> + depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
>> + select SERIAL_CORE
>> + tristate "PRUSS based SoftUART emulation on DA8XX"
>> + ---help---
>> + This driver emulates upto eight different UARTs on the PRUSS.
>
>                      up to
>
SG -- Ok Will do.


>> + You may modify the NR_SUARTS macro in the driver to emulate
>> + less number of UARTS as per your requirement.
>> + If not sure, mark N
>
>              mark N.
>
SG -- Ok Will do.


>> +    Enter the McASP number to use with SUART (0, 1 or 2).
>> + You will need to recompile the kernel if this is changed.
>
> The 2 help text lines should be indented the same.
>
SG - Ok will do.
 

