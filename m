Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab0FVMl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 08:41:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:26295 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab0FVMl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 08:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ff4Q0MZz+33N/IJBLoP2nZrUJ8Cg3thR7wE3j9cz8H7PnOc+ZVV6WuJw0jJmFnO6de
         cBsT1y5PbJT9iMvSmQQ4qhW72Zs3E8OWgWPDHJsnzhUkHEtqj4fEIqvjmU0g7DWRfRec
         1jmJPvziBkxgmnHFqeMjzqSX5pfMXSgBEiykU=
MIME-Version: 1.0
In-Reply-To: <1277210104.29532.13.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
	<1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
	<4C20702C.1080405@cs.helsinki.fi>
	<1277196403-20836-1-git-send-email-sankar.curiosity@gmail.com>
	<20100622113135.GB20140@linux-sh.org>
	<1277208351.29532.5.camel@e102109-lin.cambridge.arm.com>
	<AANLkTin9ssqksoAvafRdsogmfrDUhShHCF9aCUb7CtCl@mail.gmail.com>
	<1277210104.29532.13.camel@e102109-lin.cambridge.arm.com>
Date: Tue, 22 Jun 2010 15:41:24 +0300
X-Google-Sender-Auth: vpFN97qnIxWkUn3EXGcwSPwd1gg
Message-ID: <AANLkTim-5W0BJ955VkIUpPCrPbXXZdCEkUVOIGeDZGo0@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: config-options: Default buffer size for 
	kmemleak
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Sankar P <sankar.curiosity@gmail.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       lrodriguez@atheros.com, rnagarajan@novell.com, teheo@novell.com,
       linux-mm@kvack.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 3:35 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Tue, 2010-06-22 at 13:21 +0100, Pekka Enberg wrote:
>> On Tue, Jun 22, 2010 at 3:05 PM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > The defconfig change for this specific platform may be a better option
>> > but I thought defconfigs are to provide a stable (and maybe close to
>> > optimal) configuration without all the debugging features enabled
>> > (especially those slowing things down considerably).
>>
>> The defconfig change was definitely not a clean solution to this
>> problem. Better bake the fix in Kconfig proper even if it means
>> dependency on CONFIG_SH or something.
>
> OK, maybe something like this
>
>        default 1000 if SH
>        default 400
>
> It seems that kbuild only considers the first encounter of "default".

Sure, I'm fine with that.
