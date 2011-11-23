Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab1KWGwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:52:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33666 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab1KWGwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:52:32 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <4ECC4E1B.9050405@tilera.com>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
	<4ECC4E1B.9050405@tilera.com>
Date: Wed, 23 Nov 2011 08:52:31 +0200
Message-ID: <CAOtvUMdj--5O6xB6zzrk+kYDASHWxxRMAkN2K-2z3z5hSwzcyw@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Nov 23, 2011 at 3:36 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 11/22/2011 6:08 AM, Gilad Ben-Yossef wrote:
>> We have lots of infrastructure in place to partition a multi-core system such that we have a group of CPUs that are dedicated to
>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
>
> I think this kind of work is very important as more and more processing
> moves to isolated cpus that need protection from miscellaneous kernel
> interrupts.  Keep at it! :-)

Thank you very much. I believe it also has some small contribution to
keeping idle CPUs idle in a multi-core system. I consider this my
personal carbon offset effort :-)

My current plan is to take a look at each invocation of on_each_cpu in
core kernel code and see if it makes sense to give it a similar
treatment.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
