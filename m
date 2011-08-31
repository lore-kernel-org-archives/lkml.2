Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1HaMeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:34:05 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:60256 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755403Ab1HaMeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:34:02 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Aug 2011 06:33:53 -0600
From: emunson@mgebm.net
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, <imunsie@au1.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf sort: Improve dso sort output by separating
 unresolved samples by type
In-Reply-To: <20110831114944.25df45df@kryten>
References: <20110831114944.25df45df@kryten>
Message-ID: <afcaac2887821cb8863c87ea559ea9ff@mgebm.net>
User-Agent: Roundcube Webmail/0.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Wed, 31 Aug 2011 11:49:44 +1000, Anton Blanchard wrote:
> We currently roll up all unresolved kernel, user, hypervisor and 
> guest
> samples into the one bucket:
>
>     59.64%  [unknown]
>     22.71%  [kernel.kallsyms]
>      9.40%  libj9jit26.so
>
> We can get a much better high level view by separating these 
> unresolved
> samples by symbol type:
>
>     56.64%  [unknown:.]
>     22.71%  [kernel.kallsyms]
>      9.40%  libj9jit26.so
>      2.81%  [unknown:H]
>
> Signed-off-by: Anton Blanchard <anton@samba.org>

 Acked-by: Eric B Munson <emunson@mgebm.net>
