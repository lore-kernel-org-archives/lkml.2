Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2LQQ5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:57:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48408 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab2LQQ5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:57:03 -0500
Message-ID: <50CF4EBB.6060602@zytor.com>
Date: Mon, 17 Dec 2012 08:56:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression] 3.7 ends in APIC panic
References: <50CB3EAB.309@itwm.fraunhofer.de> <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com> <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com> <50CE0C82.20708@itwm.fraunhofer.de> <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com> <50CEE586.10800@itwm.fraunhofer.de> <20121217140238.GA626@gmail.com> <CAE9FiQWHMMCSdrSAyf-aBKV5xmj4XAcyD0R7Mi1qN40XqE3ROQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWHMMCSdrSAyf-aBKV5xmj4XAcyD0R7Mi1qN40XqE3ROQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 08:53 AM, Yinghai Lu wrote:
> On Mon, Dec 17, 2012 at 6:02 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> I suspect this needs to be fixed/improved: currently it's way
>> too easy to disable x2apic support accidentally.
>>
> 
> We can just enable x2apic by default when CONFIG_EMBEDDED is not set.
> 

Yes, although we should expect to have to blacklist hosts more aggressively.

Unfortunately we still don't have a good distinction between the
ThinkPads that have broken BIOSes when x2apic is on and those that don't.

	-hpa

