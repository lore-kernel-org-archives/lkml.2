Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab2BJN6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:58:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46324 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab2BJN6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:58:10 -0500
Message-ID: <4F352271.3030300@vflare.org>
Date: Fri, 10 Feb 2012 08:58:09 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Ajeet Yadav <ajeet.yadav.77@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xvmalloc: total_pages can be ulong
References: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com> <20120209011128.GA1926@kroah.com>
In-Reply-To: <20120209011128.GA1926@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/12 8:11 PM, Greg KH wrote:
> On Wed, Dec 28, 2011 at 11:20:51AM +0530, Ajeet Yadav wrote:
>> > From 4763266cb0077d1082d4a1ef941448e9b4eb55ca Mon Sep 17 00:00:00 2001
>> From: Ajeet Yadav<ajeet.yadav.77@gmail.com>
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

Since xvmalloc has now been replaced with zsmalloc, this patch is no 
longer required.

Thanks,
Nitin

