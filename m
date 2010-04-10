Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab0DJGXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 02:23:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55162 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0DJGXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 02:23:47 -0400
Message-ID: <4BC0193D.5030909@zytor.com>
Date: Fri, 09 Apr 2010 23:22:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jbaron@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com
Subject: Re: [PATCH 0/9] jump label v6
References: <cover.1270839564.git.jbaron@redhat.com> <20100409.231607.267279645.davem@davemloft.net>
In-Reply-To: <20100409.231607.267279645.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 11:16 PM, David Miller wrote:
> 
> Finally, please abstract out the jump label and string address
> type.  Even on 64-bit sparc all of the kernel addresses are 32-bits
> so we can use "u32" for all of the addresses jump label wants to
> record.  This will decrease the jump label section size.  There is
> at least one other 64-bit platform that can benefit from this,
> which I think is s390x if I'm not mistaken.
> 

Even on x86 they're 32 bits -- but signed.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

