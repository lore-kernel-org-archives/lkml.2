Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0DNN5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:57:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0DNN5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:57:39 -0400
Message-ID: <4BC5C9D0.20707@suse.cz>
Date: Wed, 14 Apr 2010 15:57:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.5 Thunderbird/3.0.4
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kbuild@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 0/6] kconfig: add support to show hidden options which
 have prompts
References: <4BC539DD.5040003@cn.fujitsu.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.4.2010 05:43, Li Zefan wrote:
> Usage:
>   (in menuconfig)
>   Press <Z> to show all config symbols which have prompts.
...
> Exmaple:
> 
>       --- Tracers
>       -*-   Kernel Function Tracer
>       - -     Kernel Function Graph Tracer
>       [*]   Interrupts-off Latency Tracer
>       - -   Preemption-off Latency Tracer
>       [*]   Sysprof Tracer
> 
> Here you can see 2 tracers are not selectable, and then can find
> out how to make them selectable.

This is really nice! Applied.

Michal

