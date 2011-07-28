Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1G1Tot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 15:44:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60378 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1G1Tos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 15:44:48 -0400
Message-ID: <4E31BC2D.50306@2net.co.uk>
Date: Thu, 28 Jul 2011 20:44:45 +0100
From: Chris Simmonds <chris.simmonds@2net.co.uk>
Reply-To: chris@2net.co.uk
Organization: 2net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Chris <chris@2net.co.uk>, Linux Kernel <linux-kernel@vger.kernel.org>,
        mingo@redhat.com
Subject: Re: [RFC] [PATCH] Lightweight kernel condition variables: faster
 code, fewer bugs
References: <Pine.LNX.4.44L0.1107281256240.1990-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107281256240.1990-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:Lf5/ZqapVEQ1FcdRwX0GhcylFU4AVac1VIYT9ZbHOki
 gQYaUwMFaU1vVBFutlHj/a0RAY3TQe2G81+epmLnLe4sO5xSpU
 5LrKbD59qnsv/v8n61Tu/Isawbthrg8REoFDTjkFIPLKpv6SJd
 8G896zF+FcnARDKGqFizc+i0uArWOXGn9tDKOklcH+sj0LW75x
 pIBA+hU7W3XbjpZmfGZQzTmdj1UTfH2Kyqu8RNP9s4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/11 18:00, Alan Stern wrote:
> On Wed, 27 Jul 2011, Chris Simmonds wrote:
>
>> Hi,
>>
>> This patch adds lightweight condition variables to the kernel to reduce
>> complexity and improve the efficiency of some synchronisation tasks.
>> They are very similar to POSIX condition variables.
>
> It seems like a reasonable sort of thing to do, as far as I can see.
>

Thanks, and thank you for the review.

> One little problem here.  These routines may well be large enough
> that it's inefficient to inline them.  In that case they should be
> declared in wait.h but defined somewhere else, such as kernel/wait.c.
> Conversely, if you do think they deserve to be inlined then they should
> be marked as such.

I was not planning to make them inline. I will change the patch to do as 
you say.

>
> P.S.: Does this come through checkpatch.pl unscathed?
>

In truth, no. The next one will.

Chris.
