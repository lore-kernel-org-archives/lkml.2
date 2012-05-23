Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab2EWPR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:17:56 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60308 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab2EWPRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:17:55 -0400
Message-ID: <4FBCFF28.8080703@parallels.com>
Date: Wed, 23 May 2012 19:15:52 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Rientjes <rientjes@google.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home> <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1205230947490.30940@router.home> <4FBCFBE0.2080803@parallels.com> <alpine.DEB.2.00.1205231012330.30940@router.home>
In-Reply-To: <alpine.DEB.2.00.1205231012330.30940@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 07:17 PM, Christoph Lameter wrote:
>> So if I understand it correctly, this is mostly because the name string
>> >  outlives the cache in the slub case, because of merging ?
> Well this means we really only need the copying in slub which we already
> have.
>
> The problem is that you want to make this behavior uniform over all
> allocators so that you do not have to allocate the string on your own.
>
> Could you wait (and not rely on copying) until I am through with the
> extraction project for common code for the allocators? At that point we
> can resolve this issue consistently for all allocators.
>

Yes, I can.
Let's just defer this for now.

