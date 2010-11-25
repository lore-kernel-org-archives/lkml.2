Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab0KYGqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:46:20 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46785 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0KYGqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:46:19 -0500
Message-ID: <4CEE0639.3090402@cs.helsinki.fi>
Date: Thu, 25 Nov 2010 08:46:17 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Richard Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing/slub: Move kmalloc tracepoint
 out of inline code
References: <20101124212333.808256210@goodmis.org>	 <20101124212717.468748477@goodmis.org>  <4CEDB53E.5000203@cn.fujitsu.com> <1290647846.30543.707.camel@gandalf.stny.rr.com>
In-Reply-To: <1290647846.30543.707.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/10 3:17 AM, Steven Rostedt wrote:
>> But he only touched slub.
>
> Hehe, and I forgot about it ;-) I notice the large number of kmalloc
> tracepoints while analyzing the jump label code, and wanted to do
> something about it.
>
> I also see that Pekka replied saying that he applied it.
>
> Pekka, want to take my first patch?

Sure, I'll queue it up.
