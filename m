Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab2ECXju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:39:50 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49683 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758996Ab2ECXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:39:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120503233239.GB9582@kroah.com>
References: <20120503231903.02D1D8095E@fiasco.mtv.corp.google.com>
	<20120503233239.GB9582@kroah.com>
Date: Thu, 3 May 2012 16:39:47 -0700
Message-ID: <CA+=D-XUBuaT=d=YYou5ZQKM3h9kJcsRM0HCJmLDXfXHZrth0Eg@mail.gmail.com>
Subject: Re: [PATCH] driver-core: fix DEVICE_INT_ATTR to use correct
 show/store functions
From: Michael Davidson <md@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the problem while porting some code to 3.3.

It looks as if the mce driver uses int attributes for a few things so I assume
that is broken but I have not actually verified it.

thanks,

md

On Thu, May 3, 2012 at 4:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, May 03, 2012 at 04:19:02PM -0700, Michael Davidson wrote:
>> [PATCH] driver-core: fix DEVICE_INT_ATTR to use correct show/store functions
>
> This line isn't needed again in the patch body like this :(
>
>> DEVICE_INT_ATTR() should use device_show_int() and device_store_int()
>> not device_show_ulong() and device_store_ulong()
>>
>> Signed-off-by: Michael Davidson <md@google.com>
>
> Is this something that fixes a problem you have seen, so it needs to go
> in now, and backported to stable kernel releases, or can it wait for 3.5
> and you found it just by looking at the code?
>
> thanks,
>
> greg k-h
