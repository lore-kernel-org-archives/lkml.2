Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2KLVI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:08:58 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36184 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2KLVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:08:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121112161348.GA7022@jshin-Toonie>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
	<20121110115027.GC2777@rric.localhost>
	<20121111184426.GA5415@jshin-Toonie>
	<CABPqkBQn82ga0vKOn8bZTQD6H_mk4zmA+LFgNVRb7BjAdHZjXg@mail.gmail.com>
	<20121112142233.GA24433@rric.localhost>
	<20121112161348.GA7022@jshin-Toonie>
Date: Mon, 12 Nov 2012 22:08:54 +0100
Message-ID: <CABPqkBSEzAD00mFdxSMy-vPvMfuO=9-OBxMhwooF9-kebwu_YQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
From: Stephane Eranian <eranian@google.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 5:13 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> On Mon, Nov 12, 2012 at 03:22:33PM +0100, Robert Richter wrote:
>> Stephane,
>>
>> On 12.11.12 13:24:38, Stephane Eranian wrote:
>> > Anybody from AMD or formerly @ AMD care to submit a libpfm4 patch
>> > to add the Fam15th NB events?
>> >
>> > I'd like to avoid having to type them in manually.
>>
>> Suravee may probably help you here.
>
> Suravee is out of the office until the end of the month,
>
> Is this necessary ASAP for this perf patchset to go upstream? If so,
> I'll commit to getting a patch out for libpfm4 soon.
>
> Otherwise, I'll ask Suravee to work on it when he gets back.
>
Not critical for the kernel part. USeful for user level tools beyond
perf.

> Thanks,
>
> -Jacob
>
>>
>> HTH
>>
>> -Robert
>>
>
