Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1FOS7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:59:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44906 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1FOS7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BnCZvvPwXUJvPliRd+dp/CugeQGzhnuiWE8WvbGVaDRKFj4S+lBwjCtpuPLQ3ab/5p
         /spKUNdrHm1W9wZCmoZ73ho0VS/sCJGanW3SPGT2A+/PsppSomGcfTUDbCM2gGRgmFZa
         jNuCMLVt0lSW8PTiwkls5bh9t9Oc6wEqPgrp0=
Message-ID: <4DF9011D.6050107@gmail.com>
Date: Wed, 15 Jun 2011 21:59:41 +0300
From: Alexander Zhaunerchyk <alex.vizor@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #36452] Artifacts with 3.0-rc1 on SandyBridge
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera>	<JL7O0m0yLjL.A.vCD.COS9NB@chimera> <20110615114329.7429ff43@jbarnes-desktop>
In-Reply-To: <20110615114329.7429ff43@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't bisect. I tried to bisect other other bug but with some commits 
I can't even boot, kernel hangs in panic.

On 15.06.2011 21:43, Jesse Barnes wrote:
> On Sun, 12 Jun 2011 22:30:52 +0200 (CEST)
> "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
>
>> This message has been generated automatically as a part of a summary report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.39.  Please verify if it still should be listed and let the tracking team
>> know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36452
>> Subject		: Artifacts with 3.0-rc1 on SandyBridge
>> Submitter	: Alex Zhavnerchik<alex.vizor@gmail.com>
>> Date		: 2011-06-01 13:55 (12 days old)
> Can you try bisecting this one?
>
