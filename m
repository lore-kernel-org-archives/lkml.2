Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2KZNPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:15:50 -0500
Received: from pmx.elettra.trieste.it ([140.105.206.203]:44803 "EHLO
	pmx.elettra.trieste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2KZNPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:15:49 -0500
Message-ID: <50B36B81.4010709@elettra.trieste.it>
Date: Mon, 26 Nov 2012 14:15:45 +0100
From: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Igor Grinberg <grinberg@compulab.co.il>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: Conditionally compile counter_32k
References: <1353922083-1094-1-git-send-email-alessio.bogani@elettra.trieste.it> <50B35A4D.8080501@compulab.co.il>
In-Reply-To: <50B35A4D.8080501@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.11.26.130033
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_700_799 0, FROM_NAME_PHRASE 0, NO_URI_FOUND 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_FROM 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0, __SXL_SIG_ERROR_SERVFAIL , __TO_MALFORMED_2 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

On 26/11/2012 13:02, Igor Grinberg wrote:
> On 11/26/12 11:28, Alessio Igor Bogani wrote:
[...]
>>   # Common support
>> -obj-y := sram.o dma.o fb.o counter_32k.o
>> +obj-y := sram.o dma.o fb.o
>>   obj-m :=
>>   obj-n :=
>>   obj-  :=
>>
>> +obj-$(CONFIG_OMAP_32K_TIMER) += counter_32k.o
>
> We are moving away from this config option in favor of runtime detection,

Well, I'll be happy when it'll happen.

> Why do you need this?

Because until now the build system doesn't honour the config file. 
Indeed it builds that source code file also when I set 
CONFIG_OMAP_32K_TIMER to n.

The runtime detection isn't a good excuse for doesn't make the build 
system working like users expect.

Ciao,
Alessio
