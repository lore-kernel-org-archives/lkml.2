Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab0JZJZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:25:07 -0400
Received: from mail176c2.megamailservers.com ([69.49.111.76]:40401 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939Ab0JZJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:25:05 -0400
X-Greylist: delayed 7825 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 05:25:05 EDT
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4CC67FD5.4080101@gaisler.com>
Date: Tue, 26 Oct 2010 09:14:29 +0200
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Miller <davem@davemloft.net>, namhyung@gmail.com,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sparc32: fix build failure on CONFIG_SPARC_LEON
References: <1288021958-3130-3-git-send-email-namhyung@gmail.com> <20101025.090043.71110898.davem@davemloft.net> <20101025161122.GA25358@merkur.ravnborg.org> <20101025.115331.193708760.davem@davemloft.net> <20101025194155.GA26282@merkur.ravnborg.org>
In-Reply-To: <20101025194155.GA26282@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=uRn7KoxuC2OpxNPVpS15HJzMIouaJcnXo6/pxeBsqxE= c=1 sm=1
		a=j7qZbE8i4qQA:10 a=8nJEP1OIZ-IA:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=7gkXJVJtAAAA:8 a=pGLkceISAAAA:8 a=uRll_h0sRItRsaKFR1QA:9
		a=vUEyK0UwXIUaUMdg-6eg97e_zkIA:4 a=wPNLvfGTeEIA:10 a=JmBWkid0h3cA:10
		a=MSl-tDqOz04A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sam Ravnborg wrote:

>On Mon, Oct 25, 2010 at 11:53:31AM -0700, David Miller wrote:
>  
>
>>From: Sam Ravnborg <sam@ravnborg.org>
>>Date: Mon, 25 Oct 2010 18:11:22 +0200
>>
>>    
>>
>>>On Mon, Oct 25, 2010 at 09:00:43AM -0700, David Miller wrote:
>>>      
>>>
>>>>From: Namhyung Kim <namhyung@gmail.com>
>>>>Date: Tue, 26 Oct 2010 00:52:38 +0900
>>>>
>>>>        
>>>>
>>>>>  CC      arch/sparc/kernel/irq_32.o
>>>>>arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
>>>>>arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
>>>>>          
>>>>>
>>>>I doubt SMP LEON chips even exist, so better to just anti-dep
>>>>this in arch/sparc/Kconfig
>>>>        
>>>>
>>>I have a nice eval board at my desk with a dual-core LEON4 processor.
>>>I only lack time to play with it...
>>>      
>>>
>>Ok.  But whenever someone gets a time to play with it and
>>verify it works, we can sort out this build failure by
>>modifying the code as needed.
>>
>>But for now I prefer the Kconfig SMP dependency fix.
>>    
>>
>
>Yup - I agree.
>My only intention was to tell that such a processor exists in reality
>and not only on paper.
>
I stumbled into the same problem last weeks, enabling "Normal floppy 
disk support" (BLK_DEV_FD) on the LEON makes this error appear. There is 
no hardware for "Normal floppy disk support" on a LEON.

Regards,
Daniel Hellstrom

