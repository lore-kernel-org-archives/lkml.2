Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1BORPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:15:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48944 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab1BORPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:15:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yAS3FV/EFbf3PMF4bnD3EB243RuWDjSjmsAvghRnA7lfwNFFmEOhC2HwU1BCNNKU0B
         xNniXsTcTI3oie7LS3Wbs7Q9LPJqoGMGAtRjsDuPbmQ/o732bT0MzLYda/BR1xTjIkqP
         /zR94xojvxLdOQXmDu+23iILLeDAMrjhNxKXI=
MIME-Version: 1.0
In-Reply-To: <20110215055426.GA468@in.ibm.com>
References: <AANLkTi=Ca4Lcc_war-atpr81eJcZA3ks+EKFf9Rq5pKs@mail.gmail.com>
	<20110215055426.GA468@in.ibm.com>
Date: Tue, 15 Feb 2011 12:15:08 -0500
Message-ID: <AANLkTikkLuCeWpHBU5HO=39vO_DjhQkFMmnpB4kqtEmD@mail.gmail.com>
Subject: Re: Mapping memory between kernel and user space
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As was suggested I started reading chap 15v from LDD. I ran more into
confusion state.

I know that virtual address(process space), linear address
(segmentation) and physical address. And how are they resolved from
virtual to physical.
But coming to kernel they distinguish logical address from virtual
address. What is the main difference.
Also, they emphasize on high memory and low memory. Why can not high
memory can be mapped in to kernel completely.
Why is that kernel has less visibility of complete space available on RAM.
Linux MM is it a very specific implementation of linux, or Is that a
traditional implementation.

what is very minimal implementation of MMU for real time systems.

Thanks in advance.

--Sri.

On Tue, Feb 15, 2011 at 12:54 AM, Ankita Garg <ankita@in.ibm.com> wrote:
> On Wed, Feb 09, 2011 at 06:45:42PM -0500, Sri Ram Vemulpali wrote:
>> Hi all,
>>
>>   How do I map some space between kernel and user space. Can anyone
>> point me in to right direction. I was trying to map the packets from
>> my netfilter function to kernel user space, to avoid over head of
>> copying. Thanks in advance.
>>
>
> You can take a look at remap_pfn_range() routine when implementing mmap
> in your driver.
>
> --
> Regards,
> Ankita Garg (ankita@in.ibm.com)
> Linux Technology Center
> IBM India Systems & Technology Labs,
> Bangalore, India
>



-- 
Regards,
Sri.
