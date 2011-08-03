Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1HCOAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:00:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58440 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1HCOAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110803135604.GA29761@dumpdata.com>
References: <cover.1312378163.git.luto@mit.edu> <20110803135322.GC29501@dumpdata.com>
 <20110803135604.GA29761@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 3 Aug 2011 09:59:43 -0400
X-Google-Sender-Auth: zRiuNel17RwxNqWl_wsB0Rgut3Y
Message-ID: <CAObL_7FavQH29CENHptZphDDv7ja2P9MVM5Uj47G68ccDumBBg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Collected vdso/vsyscall fixes for 3.1
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 9:56 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, Aug 03, 2011 at 09:53:22AM -0400, Konrad Rzeszutek Wilk wrote:
>> On Wed, Aug 03, 2011 at 09:31:48AM -0400, Andy Lutomirski wrote:
>> > This fixes various problems that cropped up with the vdso patches.
>> >
>> >  - Patch 1 fixes an information leak to userspace.
>> >  - Patches 2 and 3 fix the kernel build on gold.
>> >  - Patches 4 and 5 fix Xen (I hope).
>> >  - Patch 6 (optional) adds a trace event to vsyscall emulation.  It will
>> >    make it easier to handle performance regression reports :)
>>
>> Hm, you seemed to have the x86 maintainers on your email..
>
> I definitly need some coffee. What I meant was that you missing putting
> the x86 maintainers on this patchset. They are the ones that will handle this.
>
> I put them on the To list for you.

Are you sure about that coffee?  I'm pretty sure I had x86@kernel.org in there.

--Andy
