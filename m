Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1ECTAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:00:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58010 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1ECTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XZDIvfDqmIjmpD51NiKAwzMR85q2ZrAly8pYDDlu+QrnAnfgWwyfPUuLokWFbXcZWJ
         ddmJFeNc2uZV/XrReEUg==
MIME-Version: 1.0
In-Reply-To: <20110503131820.GB23498@redhat.com>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
 <1304124773-24935-1-git-send-email-vnagarnaik@google.com> <20110503131820.GB23498@redhat.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 3 May 2011 12:00:07 -0700
Message-ID: <BANLkTinqHNCzcZmQL6M-pCszTmPO=-X8yw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Change trap definitions to enumerated values
To: Don Zickus <dzickus@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 6:18 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Apr 29, 2011 at 05:52:52PM -0700, Vaibhav Nagarnaik wrote:
>> From: Aditya Kali <adityakali@google.com>
>>
>> The traps are referred to by their numbers and it can be difficult to
>> understand them while reading the code without context. This patch adds
>> enumeration of the trap numbers and replaced the numbers to the correct
>> enum for x86.
>
> My only problem with this patch is you took a straight forward conversion
> which didn't really change the functionality and sprinkled some trace
> points in there.

Actually, readability and maintainability was the goal to create the patch.
When the tracepoints are added, they can use the enum values rather than
floating magic numbers.

Thomas and Steven,
Would it make better sense to separate this patch into 2 patches, the first
one replacing the numbers to enums and the second one adding the tracepoints?


>
> I am ok with the conversion to something readable, but I don't know enough
> about the trace point to know if those are correct spots.
>
> Cheers,
> Don
>
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> ---


Thanks

Vaibhav Nagarnaik
