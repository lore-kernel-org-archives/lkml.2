Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1ECXJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:09:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab1ECXJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dNtUwD3xgKmbeXUGgXtiFod8+E7RS43uf65VC+4coO0gt4Cxq7WfDWJTGozXfWIlnv
         txyeAeNwwNjrvk/ok7Lg==
MIME-Version: 1.0
In-Reply-To: <1304463276.25414.2420.camel@gandalf.stny.rr.com>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
 <1304124773-24935-1-git-send-email-vnagarnaik@google.com> <20110503131820.GB23498@redhat.com>
 <BANLkTinqHNCzcZmQL6M-pCszTmPO=-X8yw@mail.gmail.com> <BANLkTik4N_cWuw2Vq65UX5jCW+AccQHAHw@mail.gmail.com>
 <1304463276.25414.2420.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Tue, 3 May 2011 16:08:39 -0700
Message-ID: <BANLkTik9yi8KdA33c1y2euegXYutQYWpaA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Change trap definitions to enumerated values
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, these two patches were one patch originally, and we broke it up
before sending it to you, but we made a couple mistakes:

- missed that there were still tracepoints in this patch (it's a long,
repetitive patch).
- over-estimated the resistance to this patch, and under-estimated
resistance to the tracepoint patch, so put the tracepoint patch first.

We're learning...

On Tue, May 3, 2011 at 3:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-03 at 15:41 -0700, Michael Rubin wrote:
>> On Tue, May 3, 2011 at 12:00 PM, Vaibhav Nagarnaik
>> <vnagarnaik@google.com> wrote:
>> > Would it make better sense to separate this patch into 2 patches, the first
>> > one replacing the numbers to enums and the second one adding the tracepoints?
>>
>> Yes please do that.
>> Each patch should stand on its own with one simple purpose if possible.
>
> Agreed. Don't break up patches just because of size, but instead with
> purpose. Usually this breaks up large patches as you want to build up
> something, piece by piece, where each piece has a specific, easy to
> understand goal.
>
> This is actually what is taking me so long to get my ftrace rewrite out.
> Not the actual work, but coming up with a way to break up that work in
> logical steps, that makes it easy to understand and review.
>
> -- Steve
>
>
>
