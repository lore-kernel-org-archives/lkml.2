Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab1ERTed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:34:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933632Ab1ERTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:34:32 -0400
Date: Wed, 18 May 2011 12:33:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
Message-Id: <20110518123335.62785884.akpm@linux-foundation.org>
In-Reply-To: <1305745409.2915.178.camel@work-vm>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
	<20110518062554.GB2945@elte.hu>
	<1305745409.2915.178.camel@work-vm>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 12:03:29 -0700
John Stultz <john.stultz@linaro.org> wrote:

> But, the net of this is that it seems everyone else is way more
> passionate about this issue then I am, so I'm starting to wonder if it
> would be better for someone who has more of a dog in the fight to be
> pushing these?

I like the %p thingy - it's neat and is an overall improvement.  If it
dies I shall stick another pin in my Ingo doll.

Providing an unlocked accessor for super-special applications which
know what they're doing seems an adequate compromise.
