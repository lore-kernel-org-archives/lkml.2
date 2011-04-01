Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1DALdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:33:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33804 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1DALdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ilIaCnluBTprvVjgZaaJcMP6zej5eJQqUPyqW/2LESkhX03WxINLgTf5Yww5i7MQsi
         6kNj5XNPY/mLZbfyB7R3mXS1c1Sas9YCeRRa6etJsPXfs+s3d7g4f3pTDX/CzCgSEA1p
         +wdiPIR8OjwxQKBpxSoZLreD5q3k7VqSPrDOo=
Message-ID: <4D95B80D.5010703@gmail.com>
Date: Fri, 01 Apr 2011 15:33:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] [PATCH] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
References: <4D94EF4B.6070905@gmail.com> <1301655194.4859.479.camel@twins> <4D95B160.5020605@gmail.com>
In-Reply-To: <4D95B160.5020605@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 03:05 PM, Cyrill Gorcunov wrote:
...
>>
>> is x86 the only arch using the watchdog things?
> 
> Hm, good question. The powerpc, sparc, sh, arm, mips have PERF_COUNT_HW_CPU_CYCLES.
> Seems I've missed those archs. Thanks Peter, will take a look.
> 

ok, as far as I see nmi-watchdog is x86 specific (only x86 refers to
CONFIG_HARDLOCKUP_DETECTOR at least for now).

-- 
    Cyrill
