Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1BPURg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:17:36 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:9727 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1BPURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:17:35 -0500
Message-ID: <4D5C30D8.8070107@caviumnetworks.com>
Date: Wed, 16 Feb 2011 12:17:28 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mark Wielaard <mjw@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>,
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
References: <4D5AA164.1050607@polymtl.ca>	<y0mvd0ltgba.fsf@fche.csb>	<AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com>	<1297853778.3224.90.camel@springer.wildebeest.org>	<20110216185056.CAD7B1806E0@magilla.sf.frob.com>	<20110216200034.GA6066@Krystal> <20110216200449.1EB9618020E@magilla.sf.frob.com>
In-Reply-To: <20110216200449.1EB9618020E@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2011 20:17:29.0322 (UTC) FILETIME=[88FF34A0:01CBCE16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 12:04 PM, Roland McGrath wrote:
> IMHO there is not really so much to the in-kernel implementation that it's
> worth attempting to reuse the code in userland.  Pretty much all the work
> is in the details of the implementation that would naturally differ a lot
> in a different context.  If you understand the mechanism and the machine
> details, then implementing it well for a userland context is not a big deal
> and is cleaner to do from scratch than shoe-horning kernel-centric code
> into a wildly different context.
>

Good point.

Certainly the details of maintaining instruction cache coherency may be 
different in userspace.

David Daney
