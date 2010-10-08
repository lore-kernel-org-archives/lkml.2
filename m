Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0JHJh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:37:26 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47754 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0JHJhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P7KPZrwOTymRnUv30IYvWASUGvmuIV4RXfPewhdEQB7LIPUuWfQgaQJMtXgFg7xrpm
         t2Y+TxjfemGYUiyAiveEOvVa9/9HMRXRxK7JGlk3ntnYbj2kcTiSuvKVhu+JNhS9cl6L
         1A8pJ3lkSgXyUp+Lc6HTu/fSpyClKrGX0SNy8=
MIME-Version: 1.0
In-Reply-To: <20101008092452.GE13563@erda.amd.com>
References: <1286360874-1471-1-git-send-email-robert.richter@amd.com>
	<1286360874-1471-3-git-send-email-robert.richter@amd.com>
	<20101006194150.GA17647@lenovo>
	<20101008092452.GE13563@erda.amd.com>
Date: Fri, 8 Oct 2010 13:37:24 +0400
Message-ID: <AANLkTi=6O1nUC71OiwcJBjmH-naq3ofMXyA0BqoT7Q55@mail.gmail.com>
Subject: Re: [PATCH 2/2] apic, x86: Use BIOS settings for IBS and MCE
 threshold interrupt LVT offsets
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 1:24 PM, Robert Richter <robert.richter@amd.com> wrote:
...
>> > +                   } else if (lvt_off != offset) {
>>
>> Could we put explicit type specificator here? For better readbility.
>> ...
>
> Cyrill,
>
> Do you mean an explicit type cast here, or something else?
>

Yeah, explicit type cast (not a big deal though since at moment
of course nothing can fire in this snippet, but I think for future
modifications better to have explicit cast).

>
> Thanks for review,
>
> -Robert
>

Cyrill
