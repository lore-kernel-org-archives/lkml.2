Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1HKU2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:28:09 -0400
Received: from claw.goop.org ([74.207.240.146]:40207 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1HKU2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:28:08 -0400
Message-ID: <4E443B52.3080609@goop.org>
Date: Thu, 11 Aug 2011 13:28:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/6] Collected vdso/vsyscall fixes for 3.1
References: <cover.1312378163.git.luto@mit.edu> <20110803135322.GC29501@dumpdata.com> <20110803135604.GA29761@dumpdata.com> <CAObL_7FavQH29CENHptZphDDv7ja2P9MVM5Uj47G68ccDumBBg@mail.gmail.com>
In-Reply-To: <CAObL_7FavQH29CENHptZphDDv7ja2P9MVM5Uj47G68ccDumBBg@mail.gmail.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 06:59 AM, Andrew Lutomirski wrote:
> On Wed, Aug 3, 2011 at 9:56 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
>> On Wed, Aug 03, 2011 at 09:53:22AM -0400, Konrad Rzeszutek Wilk wrote:
>>> On Wed, Aug 03, 2011 at 09:31:48AM -0400, Andy Lutomirski wrote:
>>>> This fixes various problems that cropped up with the vdso patches.
>>>>
>>>>  - Patch 1 fixes an information leak to userspace.
>>>>  - Patches 2 and 3 fix the kernel build on gold.
>>>>  - Patches 4 and 5 fix Xen (I hope).
>>>>  - Patch 6 (optional) adds a trace event to vsyscall emulation.  It will
>>>>    make it easier to handle performance regression reports :)
>>> Hm, you seemed to have the x86 maintainers on your email..
>> I definitly need some coffee. What I meant was that you missing putting
>> the x86 maintainers on this patchset. They are the ones that will handle this.
>>
>> I put them on the To list for you.
> Are you sure about that coffee?  I'm pretty sure I had x86@kernel.org in there.

What's the state of this series?  Has tip.git picked it up, or does it
need another go-around?

I just booted a Linus tree and got a backtrace that looks like this
issue, though I haven't looked into it in detail yet.

Thanks,
    J
