Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2F2Af6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 20:35:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53288 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2F2AfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 20:35:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f776d000002f3f-21-4fecf84137e6
Message-id: <4FECF841.40207@samsung.com>
Date: Fri, 29 Jun 2012 09:35:13 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] Exynos : Add support for Exynos random number generator
References: <1340851345-27107-1-git-send-email-jonghwa3.lee@samsung.com>
 <4FECAC3C.2010202@codeaurora.org>
In-reply-to: <4FECAC3C.2010202@codeaurora.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAV3HH2/8DZ71KFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MCatPMResZq9YsXouUwPjb9YuRk4OCQETiVPnmtggbDGJC/fW
	A9lcHEICixgl5ly4wwyS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9R3MUlcfj2X
	HaJeQ+LWky9MIDaLgKrE6UcTwZaxCchJvG36xggyR1QgQuJXPwdIWARozvcdJ8H2Mgt0M0ns
	/r2FESQhLOAvsfnyFbCZQgI5EqfOdIHdwymgJ/F+yQ7GCYwCs5CcNwvhvFlIzlvAyLyKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIzj8nknvYFzVYHGIUYCDUYmHN+LTG38h1sSy4srcQ4wS
	HMxKIrybpwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZZX/AXEkhPLEnNTk0tSC2CyTJxcEo1
	MFYrFdlxhWUs7t5QeDlndu6ctV/zYnWYglZE6KT6Hc+b9tfFQ3eHsJHl0uM37zR3Hpi+Ri7t
	1sEc7cbgbefr34X+SFkYoc97/mfCpvLXp+oLGyWZDI8pb7V7FctX6uqpYKw+Y4aGwpTYn67O
	J3OPsbyauPbT/X3/tDkeOYUtnlBxdc5kXevPbkosxRmJhlrMRcWJAAPSfVU7AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 06월 29일 04:10, Stephen Boyd wrote:

> On 06/27/12 19:42, Jonghwa Lee wrote:
>> This patch supports Exynos SOC's PRNG driver. Exynos's PRNG has 5 seeds and
>> 5 random number outputs. Module is excuted under runtime power management control,
>> so it activates only while it's in use. Otherwise it will be suspended generally.
>> It was tested on PQ board by rngtest program.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> I'll leave the signoff chain discrepancy to whoever applies this patch.
> 
>> +
>> +#include <linux/hw_random.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/delay.h>
> 
> Is delay.h used?
> 


No, it isn't. I forgot to remove it after testing. I'll remove it.


Best regards.
