Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab2BJKVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:21:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56908 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab2BJKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:21:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120209011128.GA1926@kroah.com>
References: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com>
	<20120209011128.GA1926@kroah.com>
Date: Fri, 10 Feb 2012 15:51:28 +0530
Message-ID: <CAB4K4y4Z7YB7uNSFfpP7TuunpwZKGVAdqQAzOfz2Ut9T24SA-g@mail.gmail.com>
Subject: Re: [PATCH] xvmalloc: total_pages can be ulong
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sure, thanks for feedback

On Thu, Feb 9, 2012 at 6:41 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Dec 28, 2011 at 11:20:51AM +0530, Ajeet Yadav wrote:
>> >From 4763266cb0077d1082d4a1ef941448e9b4eb55ca Mon Sep 17 00:00:00 2001
>> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>> Date: Wed, 28 Dec 2011 11:08:34 +0530
>> Subject: [PATCH] xvmalloc: total_pages can be ulong
>>
>> total_pages is u64, its too large value considering
>> that its in page unit on both 32-bit and 64-bit system
>> , therefore make it ulong.
>
> Your patch is line-wrapped and can not be applied.
>
> Please use the git send-email command to send the patch, otherwise bad
> things like this can happen :(
>
> Care to redo it?
>
> thanks,
>
> greg k-h
