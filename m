Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab1G0Uj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:39:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1G0UjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:39:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=vMGG8GcB8ncV5z9Psw+6hKW1knlAUVoPJslNvj0dvtDuGqNlWRHcFHiNo5bNIrPe/
	WLl+sc5Q4TsZq6lSBjeEw==
MIME-Version: 1.0
In-Reply-To: <1308151691.9218.128.camel@gandalf.stny.rr.com>
References: <1304462995-1825-1-git-send-email-vnagarnaik@google.com>
 <BANLkTimNs-iJPK67fkWdeq_Hmd2WvPSFpo9-ZL4hHOobkXaZNg@mail.gmail.com> <1308151691.9218.128.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 27 Jul 2011 13:38:51 -0700
Message-ID: <CAL26m8KHBd+40sBYoSEvi0ss1pBYrtZvSJydtkp85nn5YOFWCA@mail.gmail.com>
Subject: Re: [PATCH] x86: Change trap definitions to enumerated values
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 8:28 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-06-13 at 16:29 -0700, Vaibhav Nagarnaik wrote:
>> On Tue, May 3, 2011 at 3:49 PM, Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:
>> > From: Aditya Kali <adityakali@google.com>
>> >
>> > The traps are referred to by their numbers and it can be difficult to
>> > understand them while reading the code without context. This patch adds
>> > enumeration of the trap numbers and replaced the numbers to the correct
>> > enum for x86.
>> >
>> > Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> >
>
>> All
>>
>> Can you please go through this patch?
>
> This is very x86 specific and needs to be handled by the x86
> maintainers.
>
> Thomas, Ingo ?
>

Can the x86 maintainers please take a look at this patch?


Thanks

Vaibhav Nagarnaik
