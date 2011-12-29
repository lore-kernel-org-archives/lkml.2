Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1L2N6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 08:58:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37565 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1L2N6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 08:58:33 -0500
Message-ID: <4EFC7205.6000801@vflare.org>
Date: Thu, 29 Dec 2011 08:58:29 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xvmalloc: total_pages can be ulong
References: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com>
In-Reply-To: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ajeet,

On 12/28/2011 12:50 AM, Ajeet Yadav wrote:

> From 4763266cb0077d1082d4a1ef941448e9b4eb55ca Mon Sep 17 00:00:00 2001
> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Date: Wed, 28 Dec 2011 11:08:34 +0530
> Subject: [PATCH] xvmalloc: total_pages can be ulong
> 
> total_pages is u64, its too large value considering
> that its in page unit on both 32-bit and 64-bit system
> , therefore make it ulong.
> 
> Having done that we can use normal ++ and -- operators
> instead of stat_inc() and stat_dec(), therefore
> remove these functions as well.
> 


I'm soon going to send patches which replace xvmalloc with a new allocator.

Thanks,
Nitin
