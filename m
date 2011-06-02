Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1FBOby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:31:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48083 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1FBObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lDOviqo2EcKDeBkOncymo4n46N+peTuKfQ2CuHB7QClQ5Q4aPNLlutT1b6ILHdF0K6
         wfZtagOWFjy39r3pKm5Q4i4iCXnPi67KA+XYqcE747Fxk0WRX30QkwgTl7rsBLoj/HFp
         zcbDRnpAXyin5KElM+POx8dW41ceArGoK4GnY=
Date: Thu, 2 Jun 2011 22:31:41 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [Patch] cris: add missing declaration of kgdb_init() and
 breakpoint()
Message-ID: <20110602143141.GD4416@cr0.redhat.com>
References: <BANLkTimdog_wi+7_Vx7Qzpc0ZYor_RHg2g@mail.gmail.com>
 <20110601151618.15759bfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601151618.15759bfb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 03:16:18PM -0700, Andrew Morton wrote:
>On Sun, 22 May 2011 22:42:56 +0800
>Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
>
>> --- a/arch/cris/arch-v10/kernel/irq.c
>> +++ b/arch/cris/arch-v10/kernel/irq.c
>> @@ -20,6 +20,9 @@
>>  #define crisv10_mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
>>  #define crisv10_unmask_irq(irq_nr) (*R_VECT_MASK_SET = 1 << (irq_nr));
>>  
>> +extern void kgdb_init(void);
>> +extern void breakpoint(void);
>
>They should be declared in a header file, please. 
>arch/cris/arch-v32/kernel/irq.c has a private declaration of
>kgdb_init(), too.
>

Yeah, but I don't find a proper header to declare them.

Thanks.
