Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0EMHXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:23:05 -0400
Received: from mail.lang.hm ([64.81.33.126]:45956 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab0EMHXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:23:03 -0400
Date: Thu, 13 May 2010 00:22:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Borislav Petkov <bp@alien8.de>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: system locks up when CD burn fails
In-Reply-To: <20100513070531.GA8491@liondog.tnic>
Message-ID: <alpine.DEB.2.01.1005130021140.8603@asgard.lang.hm>
References: <alpine.DEB.2.01.1005121530090.8603@asgard.lang.hm> <20100513070531.GA8491@liondog.tnic>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Borislav Petkov wrote:

> From: david@lang.hm
> Date: Wed, May 12, 2010 at 03:35:06PM -0700
>
>> I have a couple hundred boxes running kernels from 2.6.12 through
>> 2.6.33.3 that each burn a backup to a IDE CD-ROM once a week. Every
>> couple of months one of the boxes (_not_ the same one each time)
>> runs into some sort of error when burning the CD and the entire box
>> locks up (unable to toggle numlock even). I have not been able to
>> find any correlation between failures and anything on the system.
>>
>> when the system locks up it doesn't log anything, and the screen
>> just freezes in the middle of the cdrecord status (X of Y MB
>> written) with no error message.
>>
>> I'm actually not worried that much about the burn failing, The
>> problem is that the burn failing will take out the entire system. Is
>> there anything that I should be doing to make the systems more
>> robust in the face of such failures?
>
> Are you using the ide drivers or libata? If it is the first, try
> switching to libata to see whether this fixes your freezes.

most of the boxes are using the ide drivers. Unfortunantly the problem is 
very intermittent (every few thousand disks burned I get a problem)

I'm upgrading them all to 2.6.33.3 with the libata drivers within the next 
few days, so we'll see what happens over the next couple of months.

David Lang
