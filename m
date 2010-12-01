Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0LAISy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:18:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41583 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0LAISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:18:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MHReX4WkqcC1dd2JLoGEae4NQsSGJV5DA/RIKUWbOkdj5AbCyBD6Z8qVL6qbCvvJcT
         ct9qyTjWLBh9MkG1xtt8ne2DJGqHApakqeHbfRRZ5mf904RqGqkCla3NlZ+p+DeXPq7b
         STGDymA0GjgSIeZzlEwQjCOSMLV4QtHRvmvNk=
MIME-Version: 1.0
In-Reply-To: <20101201052232.GL2746@balbir.in.ibm.com>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
	<20101130101602.17475.32611.stgit@localhost6.localdomain6>
	<20101130142509.4f49d452.akpm@linux-foundation.org>
	<20101201045421.GG2746@balbir.in.ibm.com>
	<20101201052232.GL2746@balbir.in.ibm.com>
Date: Wed, 1 Dec 2010 17:18:52 +0900
Message-ID: <AANLkTine=1YW6RHDOwYR5Kq_6ENimf=OUbOgeo1pd8uZ@mail.gmail.com>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages
From: Minchan Kim <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 2:22 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> [2010-12-01 10:24:21]:
>
>> * Andrew Morton <akpm@linux-foundation.org> [2010-11-30 14:25:09]:
>> > So you're OK with shoving all this flotsam into 100,000,000 cellphones?
>> > This was a pretty outrageous patchset!
>>
>> I'll do a better one, BTW, a lot of embedded folks are interested in
>> page cache control outside of cgroup behaviour.

Yes. Embedded people(at least, me) want it. That's because they don't
have any swap device so they could reclaim only page cache page.
And many page cache pages are mapped at address space of
application(ex, android uses java model so many pages are mapped by
application's address space). It means it's hard to reclaim them
without lagging.
So I have a interest in this patch.

-- 
Kind regards,
Minchan Kim
