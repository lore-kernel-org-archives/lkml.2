Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0DMWUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 18:20:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61159 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0DMWUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 18:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=PP+5qhjs5Sc4KNmFKF4Du7Pzh9XVsU1+p3BlEKqY3fEC2RVk9Luc/JymCvZXDMbkWo
         Uism675/VVDWXOAIgW6O+oDdfilv8ub3+tuZ7MF1+WvgFoQvmKv4iuZppYn7yKqeI+1A
         B6C3gNC6wxCIaemANxxuArRYauI3MzI6v2GZc=
MIME-Version: 1.0
In-Reply-To: <x2t9c2470ce1004062105g83a050d0gc2269e4a8af7ae05@mail.gmail.com>
References: <p2r9c2470ce1004062104ra6b9c662uf303fb1b9e82cd6@mail.gmail.com>
	 <x2t9c2470ce1004062105g83a050d0gc2269e4a8af7ae05@mail.gmail.com>
Date: Wed, 14 Apr 2010 00:20:31 +0200
Message-ID: <r2h9c2470ce1004131520naf637fbdj9a41a0d28ada3db6@mail.gmail.com>
Subject: Re: [PATCH] build error drivers/staging/dt3155/dt3155_drv.c
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 7 kwietnia 2010 06:05 u¿ytkownik Jan III Sobieski
<jan3sobi3ski@gmail.com> napisa³:
> W dniu 7 kwietnia 2010 06:04 u¿ytkownik Jan III Sobieski
> <jan3sobi3ski@gmail.com> napisa³:
>> Hi,
>>
>>  CC      drivers/staging/dt3155/dt3155_drv.o
>> drivers/staging/dt3155/dt3155_drv.c: In function 'init_module':
>> drivers/staging/dt3155/dt3155_drv.c:1047: error: implicit declaration
>> of function 'request_irq'
>> drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_SHARED'
>> undeclared (first use in this function)
>> drivers/staging/dt3155/dt3155_drv.c:1048: error: (Each undeclared
>> identifier is reported only once
>> drivers/staging/dt3155/dt3155_drv.c:1048: error: for each function it
>> appears in.)
>> drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_DISABLED'
>> undeclared (first use in this function)
>> drivers/staging/dt3155/dt3155_drv.c: In function 'cleanup_module':
>> drivers/staging/dt3155/dt3155_drv.c:1091: error: implicit declaration
>> of function 'free_irq'
>> make[3]: *** [drivers/staging/dt3155/dt3155_drv.o] B³±d 1
>> make[2]: *** [drivers/staging/dt3155] B³±d 2
>> make[1]: *** [drivers/staging] B³±d 2
>> make: *** [drivers] B³±d 2
>
> BTW. Kernel 2.6.34-rc3-git6

I still get this bug on 2.6.34-rc4. Anyone care to pick this patch?

-- 
Jan III Sobieski
