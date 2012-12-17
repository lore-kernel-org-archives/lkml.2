Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2LQRDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:03:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53458 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2LQRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:03:08 -0500
MIME-Version: 1.0
In-Reply-To: <50CF4EBB.6060602@zytor.com>
References: <50CB3EAB.309@itwm.fraunhofer.de>
	<CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
	<CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com>
	<50CE0C82.20708@itwm.fraunhofer.de>
	<CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
	<50CEE586.10800@itwm.fraunhofer.de>
	<20121217140238.GA626@gmail.com>
	<CAE9FiQWHMMCSdrSAyf-aBKV5xmj4XAcyD0R7Mi1qN40XqE3ROQ@mail.gmail.com>
	<50CF4EBB.6060602@zytor.com>
Date: Mon, 17 Dec 2012 09:03:06 -0800
X-Google-Sender-Auth: gxPhzRgDaYC8O6Damwe1pj4Pt_s
Message-ID: <CAE9FiQX=7R8MWo9iUPdi8tt4b7yozEcjNnSh8RvsmAduAbP+LA@mail.gmail.com>
Subject: Re: [regression] 3.7 ends in APIC panic
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 8:56 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/17/2012 08:53 AM, Yinghai Lu wrote:
>> On Mon, Dec 17, 2012 at 6:02 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> I suspect this needs to be fixed/improved: currently it's way
>>> too easy to disable x2apic support accidentally.
>>>
>>
>> We can just enable x2apic by default when CONFIG_EMBEDDED is not set.
>>
>
> Yes, although we should expect to have to blacklist hosts more aggressively.
>
> Unfortunately we still don't have a good distinction between the
> ThinkPads that have broken BIOSes when x2apic is on and those that don't.

last version for that blacklist patch in the bugster should be ok for
thinkpad now.

BTW, when can we have ioapic id > 255 ?

system with more than 256 sockets and IIO in it, should need that
support, right?

Yinghai
