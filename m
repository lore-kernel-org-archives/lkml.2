Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1HFLmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:42:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65244 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1HFLmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110805094319.GA2420@elte.hu>
References: <cover.1312386029.git.luto@mit.edu> <5bec80947da3fb72f2f18fbe6d924a69f83fbed9.1312386029.git.luto@mit.edu>
 <alpine.LFD.2.02.1108031214470.22067@x980> <CAObL_7GuAmzyjo5AmYxbTeiAqFtVk1N+opzWEzwJu8Mgrvts7g@mail.gmail.com>
 <CAObL_7FNa20Hsd0v-hs1vz=ejnkdaT+Yr=wwM681GbZJiuLkMQ@mail.gmail.com>
 <alpine.LFD.2.02.1108031514550.22067@x980> <20110804194117.GA5265@srcf.ucam.org>
 <alpine.LFD.2.02.1108041751360.24626@x980> <20110804215619.GA7101@srcf.ucam.org>
 <20110805094319.GA2420@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 6 Aug 2011 07:42:22 -0400
X-Google-Sender-Auth: H7TRmK8-jsYc_aUh_v8H2GApP40
Message-ID: <CAObL_7FAcv2vo=+8jooh394BTp_5WYCvRQ+FyVr3mfVPRxZgkA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't already
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 5:43 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> On Thu, Aug 04, 2011 at 05:54:04PM -0400, Len Brown wrote:
>> > > We can't trust BIOS authors to get things right. Where we can reliably
>> > > fix up things that are broken, we should do so.
>> >
>> > How about if we can get a BIOS fix for this brand new system,
>> > then we shall not clutter the kernel with a workaround, otherwise
>> > we shall.
>>
>> It's a pretty good rule of thumb that if a BIOS bug is present in
>> one BIOS it's present in others, but the users will just never
>> notice.
>
> Yes. There's no harm really from working around a BIOS bug and
> warning about it - when the BIOS gets fixed the warning message will
> go away.
>
> Btw., few people risk upgrading their BIOSen on already purchased
> hardware. I almost never do it, i only do it if it's impossible to
> continue with a current BIOS.

I do it, but I understand the sentiment.  I've destroyed laptops with
BIOS upgrades, and the new Intel BIOS seems to insist on spewing
garbage into my keyboard input when Linux (but not grub) starts.

Updates patches coming.

>
> Thanks,
>
>        Ingo
>
