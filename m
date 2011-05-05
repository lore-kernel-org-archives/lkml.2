Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab1EEGqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:46:47 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:64261 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750821Ab1EEGqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:46:46 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Thu, 05 May 2011 02:46:42 -0400
Message-ID: <web-518291056@zbackend1.aha.ru>
In-Reply-To: <20110505060204.GA28015@elte.hu>
References: <20110504142532.GC17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home>
 <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
 <alpine.DEB.2.00.1105041023070.5495@router.home>
 <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com>
 <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
 <web-518008166@zbackend1.aha.ru>
 <web-518059420@zbackend1.aha.ru>
 <20110505060204.GA28015@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Just now I compiled 2.6.39-rc6-git1 (including still 
the patchs by hand because not yet included), its also OK, 
good running, without all these problems.  :)

Yes, I continue with my everythingyesconfig, which all the 
time and also now
after this patchs gives good generic kernels for the 
distro, working good on my
server and on the laptops of the neighbours except that 
sometimes
(instead of ELAN) I'll make 486 binaries. And now put the 
package on the mirrors because everything is OK, and I 
dont need to switch on and off the server so that they can 
sync, and the users can use the now working packages of 
2.6.39-rcX ,
which have many new drivers and other good improvements.

Like since years, I continue to compile new versions since 
-rc1 and report problems.
But it was very important that Linus take care of these 
problems now, because
nobody else searched for the reasons. These bugs in logfs 
and in slub.c and percpu.h
probably were processor-type / arch independent, and would 
have given problems
for the most users, so that they could not have been 
ignored.
wl




=======================================================
On Thu, 5 May 2011 08:02:04 +0200
  Ingo Molnar <mingo@elte.hu> wrote:
> 
> * werner <w.landgraf@ru.ru> wrote:
> 
>> I'll test the patchs with a 486 config, switching off 
>>ELAN.
> 
> I think you can skip all those other test suggestions in 
>this thread - as you 
> confirmed in this email the root cause of your crashes 
>has been found.
> 
> So the best testing you could do would be for you to 
>resume testing whatever 
> original config you were using on your system, and make 
>sure there's really no 
> crashes left - and report any other regressions you 
>might see.
> 
> Thanks,
> 
> 	Ingo
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
