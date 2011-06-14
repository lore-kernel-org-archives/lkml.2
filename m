Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1FNAoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:44:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1FNAoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=WcZmOgj1O+mlZtzdkNoE9lvLHdOH0Sln3ZxJYW99xh16pQxtVrNE9+W5ycAz3hE0fa
         zmicrfrwS8FvA46InOvA==
MIME-Version: 1.0
In-Reply-To: <1308011835.9218.104.camel@gandalf.stny.rr.com>
References: <20110609172744.333794089@goodmis.org> <20110609172910.950101158@goodmis.org>
 <20110613101248.GC30962@elte.hu> <1307965185.9218.53.camel@gandalf.stny.rr.com>
 <20110613114904.GD10960@elte.hu> <1307966043.9218.63.camel@gandalf.stny.rr.com>
 <BANLkTikssQhJu3t=ikpbq11oGeV2D3L-Zc1TuVW0+TKBqmkXyw@mail.gmail.com> <1308011835.9218.104.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 13 Jun 2011 17:43:45 -0700
Message-ID: <BANLkTi=Lh2LkYRtT8UmwcxO4g1hF5VdoC+4zVC1=wqrpsZ5ECw@mail.gmail.com>
Subject: Re: [PATCH 03/15] tracing: Add a free on close control mechanism for buffer_size_kb
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 5:37 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-06-13 at 13:01 -0700, Vaibhav Nagarnaik wrote:
>
>> I have created the patch.
>>
>> I was wondering what would you consider a good name for the new proc
>> file? David suggested "free_ring_buffer".
>
> Since we already have a "buffer_size" "free_buffer" should be a good
> name.
>

Sure. Sending updated patch.



Vaibhav Nagarnaik
