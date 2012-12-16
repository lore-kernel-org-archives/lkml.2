Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2LPRnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:43:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57151 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2LPRnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:43:41 -0500
MIME-Version: 1.0
In-Reply-To: <50CB3EAB.309@itwm.fraunhofer.de>
References: <50CB3EAB.309@itwm.fraunhofer.de>
Date: Sun, 16 Dec 2012 09:43:40 -0800
X-Google-Sender-Auth: _rfbqc8npEuZVWzDS0sJfX7bicw
Message-ID: <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
Subject: Re: [regression] 3.7 ends in APIC panic
From: Yinghai Lu <yinghai@kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 6:58 AM, Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:
> On 12/13/2012 01:16 PM, Bernd Schubert wrote:
>>
>> Hello,
>>
>> I just tried to boot 3.7 and it ends in an APIC panic. I tried to use
>> the recommended "apic=debug", but that does not change anything in the
>> output, at least not in the visible part. The last known kernel to boot
>> was 3.5. If it matters I can try to boot 3.6.
>
>
> So linux-3.6 also boots. Any idea what is going on or do I really need to
> bisect?

interesting, your system have

x2apic enabled by BIOS, switching to x2apic ops

so can you try to append "nox2apic" to command line with v3.7, to see
if we can get dmesg there?

Thanks

Yinghai
