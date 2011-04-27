Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1D0KG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:06:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33278 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab1D0KG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:06:57 -0400
Message-ID: <4DB7EA5E.7000507@mvista.com>
Date: Wed, 27 Apr 2011 14:05:18 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        "Kevin Hilman \(supporter:TI DAVINCI MACHIN...,commit_signer:15/17=88%\)" 
	<khilman@ti.com>,
        "Russell King (maintainer:ARM PORT)" <linux@arm.linux.org.uk>,
        "Michael Williamson (commit_signer:6/17=35%)" 
	<michael.williamson@criticallink.com>,
        "Cyril Chemparathy (commit_signer:3/17=18%)" <cyril@ti.com>,
        "Sergei Shtylyov (commit_signer:2/17=12%)" <sshtylyov@ru.mvista.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/11] da850: pruss platform specific additions.
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-4-git-send-email-subhasish@mistralsolutions.com> <4DB6A736.3030609@mvista.com> <0A4FA4CFE83C4DD4BA36491027E93552@subhasishg>
In-Reply-To: <0A4FA4CFE83C4DD4BA36491027E93552@subhasishg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-04-2011 10:43, Subhasish Ghosh wrote:

>>> #include<mach/edma.h>
>>> @@ -73,6 +75,7 @@ extern unsigned int da850_max_speed;
>>> #define DA8XX_DDR2_CTL_BASE 0xb0000000
>>> #define DA8XX_ARM_RAM_BASE 0xffff0000
>>> #define DA8XX_SHARED_RAM_BASE 0x80000000
>>> +#define DA8XX_PRUSS_MEM_BASE 0x01C30000

>> Keep the list sorted please. Also, this macro doesn't seem used outside
>> devices-da8xx.c, so should be moved there...

> SG - But would it not be better to have all device addresses at the same place.

    They are not at the same place already -- which is intentional. The ones 
used locally in devices-da8xx.c should be #define'd there.

WBR, Sergei
