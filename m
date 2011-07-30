Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab1G3HnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 03:43:01 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:41526 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1G3Hm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 03:42:58 -0400
In-Reply-To: <CAPM=9txTVVxvv85kcZqBVjmpVK1zsAvVarLv1Sm7viwfF+ZYyA@mail.gmail.com>
References: <20110724130336.GA2116@ime.usp.br> <CAPM=9txTVVxvv85kcZqBVjmpVK1zsAvVarLv1Sm7viwfF+ZYyA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <67AE5A41-F50F-4616-B9E1-437CAD9379D3@ime.usp.br>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Rog=E9rio_Theodoro_de_Brito?= <rbrito@gmail.com>
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [REGRESSION] [BISECTED] Unable to use 3D with Radeon 2100 and UI freezes with Firefox
Date: Sat, 30 Jul 2011 04:42:52 -0300
To: Dave Airlie <airlied@gmail.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi once again, but things are not good with any kernel past the  
reworked IRQ stuff.

On 2011-07-25, at 05:08, Dave Airlie wrote:

> 2011/7/24 Rogério Brito <rbrito@ime.usp.br>:
>> After experiencing problems with many post 2.6.38 kernels with X  
>> when I used
>> Firefox to see any webpage that used some of the new HTML5  
>> features (Firefox
>> freeze completely X and I could only log in remotely with SSH), I  
>> took some
>> time to see where things went wrong and, to cut a long story short, I
>> bisected the kernel and I found that a commit of yours was the  
>> first one
>> that introduced a problem with my system:
>
> Can you attach /proc/interrupts as well please.

It seems that the radeon thing is just one of the manifestations of  
the problem.

Today, I noticed another bad symptom, when I accidentally booted with  
kernel 3.0 (I have many kernels in GRUB2): I printed a LaTeX document  
with only 2 pages of pure text.  My printer is an inkjet printer  
connected via USB to my computer and it took about 6 minutes to print  
those 2 pages. The printer head moved printing something, then it  
paused a bit, then it printed some more, then it paused some more etc.

I just rebooted with 2.6.38 and the very same document was printed  
in, like, 15 seconds...

So, is there anything that I could do to rectify this situation? I  
can give you loads of dumps from here, as long as you tell me what  
would be useful.


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br



