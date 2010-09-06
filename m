Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab0IFNlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:41:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42956 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0IFNle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WzFlpDiM5x3mOgNks0uDmwwCcl8n4RAKRDVTMEilkXC26V0525Oc6vwEmlaUx7T1It
         JwOdYLpHnItbAmE74LuX0P/oWV2KZjOwrfyYabq2ffjilWiWuXArmrHzu0IQ6VZ3s4gb
         T1Cj/lhuFYq4AKhlgVISANCj5sdEMJ1dEXGb8=
MIME-Version: 1.0
In-Reply-To: <20100906125905.GA25414@elte.hu>
References: <4C84B088.5050003@redhat.com>
	<1283772256.1930.303.camel@laptop>
	<4C84D1CE.3070205@redhat.com>
	<1283774045.1930.341.camel@laptop>
	<4C84D77B.6040600@redhat.com>
	<20100906124330.GA22314@elte.hu>
	<4C84E265.1020402@redhat.com>
	<20100906125905.GA25414@elte.hu>
Date: Mon, 6 Sep 2010 16:41:33 +0300
X-Google-Sender-Auth: GMOpPMcry2C4Kzl_CgjzEK0bHfs
Message-ID: <AANLkTin8Ggcu=PYhfNbjFwSkL3=UZL40UQH+1WD5Hz6p@mail.gmail.com>
Subject: Re: disabling group leader perf_event
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2010 03:43 PM, Ingo Molnar wrote:
>> > Yes. The filter engine is a safe, in-kernel interpreted language in
>> > the making. The C syntax was chosen because it's close to the heart
>> > of every kernel developer.
>> >
* Avi Kivity <avi@redhat.com> wrote:
>> > It might make sense to bring this concept a few steps further. Looks
>> > rather complex but also rather cool ...
>>
>> Is this a roundabout way of saying "jit"?

On Mon, Sep 6, 2010 at 3:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Partly. I'm not sure we want to actually upload programs in bytecode
> form. ASCII is just fine - just like a .gz Javascript is fine for web
> apps. (and in most cases compresses down better than the bytecode
> equivalent)
>
> So a clear language (the simpler initially the better) plus an in-kernel
> compiler.
>
> This could be used for far more than just instrumentation: IMO security
> policies could be expressed in such a way. (Simplified, they are quite
> similar to filters installed on syscall entry/exit, with the ability of
> the filter to influence whether the syscall is performed.)

Filter engine? I've never heard of it before. Where does it live?
