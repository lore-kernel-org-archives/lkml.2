Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab2E3EUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:20:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39640 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2E3EUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:20:44 -0400
Message-ID: <4FC5A018.8070001@gmail.com>
Date: Tue, 29 May 2012 22:20:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf build failure
References: <20120530040854.GA4626@linux.vnet.ibm.com>
In-Reply-To: <20120530040854.GA4626@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/12 10:08 PM, Pradeep Kumar Surisetty wrote:
> perf build failed on 3.4.0+ linus tree.
> Error meesage seems like this
>
>      LINK perf
>      libperf.a(pmu.o): In function `pmu_format_parse':
>      /home/linux/tools/perf/util/pmu.c:47: undefined reference to
>      `perf_pmu_in'
>      libperf.a(pmu-bison.o): In function `perf_pmu_parse':
>      /home/linux/tools/perf/util/pmu-bison.c:1287: undefined reference to
>      `perf_pmu_lex'
>      collect2: ld returned 1 exit status
>      make: *** [perf] Error 1

Were flex and bison installed prior to this build attempt or did you 
install after a failure and then pickup the build again? If so, try 
'make clean' followed by make again.

David
