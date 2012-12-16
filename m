Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2LPRpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:45:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52833 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2LPRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:45:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
References: <50CB3EAB.309@itwm.fraunhofer.de>
	<CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
Date: Sun, 16 Dec 2012 09:45:38 -0800
X-Google-Sender-Auth: h_NNt7-Am3MEvZ-n8c22lSVJYHE
Message-ID: <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com>
Subject: Re: [regression] 3.7 ends in APIC panic
From: Yinghai Lu <yinghai@kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 9:43 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Dec 14, 2012 at 6:58 AM, Bernd Schubert
> <bernd.schubert@itwm.fraunhofer.de> wrote:
>> On 12/13/2012 01:16 PM, Bernd Schubert wrote:
>>>
>>> Hello,
>>>
>>> I just tried to boot 3.7 and it ends in an APIC panic. I tried to use
>>> the recommended "apic=debug", but that does not change anything in the
>>> output, at least not in the visible part. The last known kernel to boot
>>> was 3.5. If it matters I can try to boot 3.6.
>>
>>
>> So linux-3.6 also boots. Any idea what is going on or do I really need to
>> bisect?
>
> interesting, your system have
>
> x2apic enabled by BIOS, switching to x2apic ops
>
> so can you try to append "nox2apic" to command line with v3.7, to see
> if we can get dmesg there?

can you post your .config for v3.7 ?

wonder if you have x2apic in .config

Thanks

Yinghai
