Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1BMKFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 05:05:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63678 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1BMKFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 05:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=skPPUwIgUJ3hn78x0kiEtlj46ZxI/fJo2SS3Ck33AbPLjw8z+5zgfPEIEWANpcHZcm
         52CGLVgHVSVJ2L7rKuKkl7Vb2787msRlYL6eOPVB9jH5RbQX+dp4sBxpQhrBfBzh26aW
         pAIFq9R541RV4+XQRfPD9kmVOvSV+Ok2EFrjc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimp5Ho1MLcJov+sBbz9qH9OFLuiCyf1wiQjyfqB@mail.gmail.com>
References: <AANLkTimp5Ho1MLcJov+sBbz9qH9OFLuiCyf1wiQjyfqB@mail.gmail.com>
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Sun, 13 Feb 2011 13:35:03 +0330
Message-ID: <AANLkTinzkboRxgiHE=SDzS9htaZ-nusg8J+hRMZeKZ9C@mail.gmail.com>
Subject: Re: ubuntu boot problem after compiling new kernel
To: Matt <jackdachef@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Anca Emanuel <anca.emanuel@gmail.com>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Matt,

https://help.ubuntu.com/community/Kernel/Compile  worked for me :)

On Sat, Feb 12, 2011 at 2:30 AM, Matt <jackdachef@gmail.com> wrote:
>>Thanks Chris and Anca,
>
>>I tried to compile latest kernel(2.6.37). but I receive an assembly
>>error: /include/trace/events/kmem.h:45: undefined reference to
>>'.L1747'. I didn't have any error at linux-2.6.18.1 compilation. I
>>read somewhere that kernel should be compiled by gcc-3.4 .  Thus I
>>used gcc-3.4 to compile. Do you think it's a compiler issue? Should I
>>use another gcc version?
>>Sorry for asking stupid questions from you experts. I'm a newbie at
>>working with kernel.
>
>>Thanks in advance
>
> Hi Amirali,
>
> perhaps for 2.6.18* gcc-3.4* is used
>
> but with 2.6.37 you could use the included gcc-4.4.3 (in Ubuntu 10.04)
> and gcc-4.4.4
> (according to http://distrowatch.com/table.php?distribution=ubuntu)
>
> that worked fine for me in the past.
>
> I don't know if you have full access to it but:
>
> help.ubuntu.com - which is a sort of wiki for Ubuntu can be very
> helpful in those things :)
>
>
> https://help.ubuntu.com/community/Kernel/Compile
>
> might help
>
>
> If a pre-built vanilla-kernel is alright for you, you can also use the
> ones provided by Ubuntu:
>
> http://lwn.net/Articles/321473/
> https://wiki.ubuntu.com/Kernel/MainlineBuilds?action=show&redirect=KernelMainlineBuilds
>
>
> I hope that's what you're looking for
>
>
> Regards
>
> Matt
>



-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
