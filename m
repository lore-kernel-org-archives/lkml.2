Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2HJRME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:12:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60794 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab2HJRMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:12:00 -0400
Message-ID: <502540D1.9020908@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2012 10:11:45 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/16] perf symbol: remove unused 'end' arg in kallsyms
 parse cb
References: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com> <1344550721-21024-3-git-send-email-cody@linux.vnet.ibm.com> <87k3x7wjvk.fsf@sejong.aot.lge.com>
In-Reply-To: <87k3x7wjvk.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081017-5930-0000-0000-00000ABB8680
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess that length of 1 effectively same as zero length in this case
> since we end up calling symbols__fixup_end. The 'end - start + 1' part
> looks like a leftover from previous change and not needed anymore -
> KSYM_NAME_LEN check too, IMHO - so I suggest using 0 length to make it
> clear.

Got it.

> And it seems you need to rebase the series onto Arnaldo's current
> perf/core branch which separates out ELF bits to symbol-elf.c.

Will do. It apparently wasn't pushed out when I sent these patches, look 
for v2 shortly.

