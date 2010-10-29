Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507Ab0J2NLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:11:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53364 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761494Ab0J2NLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PBAvRR9rAs3WApmqNU7lVHQoRtHLwIidF8/QmSypFNW+5Ke4js56PzUwOnhgEecpbh
         DjEi8HKI8VHOWP8f5eW4/GQ5M4HR4RM19Y4PTBYaVVgTZtDBDLxEUVkm9nsMuCQNd3T9
         aLc3H2EEqYDy4YRYf5b1PcTfAtZs+N96CLt70=
MIME-Version: 1.0
In-Reply-To: <20101029103154.GA10823@gargoyle.fritz.box>
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
	<op.vlbywq137p4s8u@pikus>
	<20101029103154.GA10823@gargoyle.fritz.box>
Date: Fri, 29 Oct 2010 22:11:03 +0900
Message-ID: <AANLkTin2Q-qQSnzc9sZnP_inf+5SEgG5cXYA8f-0goYG@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
From: Minchan Kim <minchan.kim@gmail.com>
To: Andi Kleen <andi.kleen@intel.com>
Cc: =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/29 Andi Kleen <andi.kleen@intel.com>:
>> When I was posting CMA, it had been suggested to create a new migration type
>> dedicated to contiguous allocations.  I think I already did that and thanks to
>> this new migration type we have (i) an area of memory that only accepts movable
>> and reclaimable pages and
>
> Aka highmem next generation :-(

I lost the road. What is highmem next generation?
Could you point it to me?

-- 
Kind regards,
Minchan Kim
