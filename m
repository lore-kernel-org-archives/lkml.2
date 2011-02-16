Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1BPUOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:14:43 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:9678 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1BPUOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:14:41 -0500
Message-ID: <4D5C3024.6040807@caviumnetworks.com>
Date: Wed, 16 Feb 2011 12:14:28 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Roland McGrath <roland@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Porting "jump labels" to userspace
References: <4D5AA164.1050607@polymtl.ca> <y0mvd0ltgba.fsf@fche.csb> <AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com> <1297853778.3224.90.camel@springer.wildebeest.org> <20110216185056.CAD7B1806E0@magilla.sf.frob.com> <20110216200034.GA6066@Krystal>
In-Reply-To: <20110216200034.GA6066@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2011 20:14:33.0584 (UTC) FILETIME=[203FB700:01CBCE16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 12:00 PM, Mathieu Desnoyers wrote:
[...]>
> Actually, creating the equivalent of the jump labels for userspace is on our
> list of "things to do" for the UST project.
>
> If Jason and other jump label contributors agree to dual-license the jump label
> generic and per-arch implementations under both GPLv2 and LGPLv2.1, we could
> probably re-use a large part of this code to create a static jump label library
> for userspace. The concerned authors are precisely: Jason for generic and x86
> code, Steven for some improvements in generic code and David S. Miller for the
> sparc port. After things settle down with the current jump label changes
> proposed by Peter Zijlstra, we might also want to ask for his permission to
> LGPLize his changes.
>
FWIW:  MIPS jump label support is now in as of:

94bb0c1 (MIPS: jump label: Add MIPS support.)

I would be the author of that.

David Daney
