Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1G3IK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 04:10:29 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61688 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1G3IKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 04:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <67AE5A41-F50F-4616-B9E1-437CAD9379D3@ime.usp.br>
References: <20110724130336.GA2116@ime.usp.br>
	<CAPM=9txTVVxvv85kcZqBVjmpVK1zsAvVarLv1Sm7viwfF+ZYyA@mail.gmail.com>
	<67AE5A41-F50F-4616-B9E1-437CAD9379D3@ime.usp.br>
Date: Sat, 30 Jul 2011 09:10:22 +0100
Message-ID: <CAPM=9tznbmkMnTcUDw-KAGeZQcqyZpsNwb74-JV9Y-d0Z3Sg1w@mail.gmail.com>
Subject: Re: [REGRESSION] [BISECTED] Unable to use 3D with Radeon 2100 and UI
 freezes with Firefox
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Rog=E9rio_Theodoro_de_Brito?= <rbrito@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 8:42 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
> Hi once again, but things are not good with any kernel past the reworked IRQ
> stuff.
>
> On 2011-07-25, at 05:08, Dave Airlie wrote:
>
>> 2011/7/24 Rogério Brito <rbrito@ime.usp.br>:
>>>
>>> After experiencing problems with many post 2.6.38 kernels with X when I
>>> used
>>> Firefox to see any webpage that used some of the new HTML5 features
>>> (Firefox
>>> freeze completely X and I could only log in remotely with SSH), I took
>>> some
>>> time to see where things went wrong and, to cut a long story short, I
>>> bisected the kernel and I found that a commit of yours was the first one
>>> that introduced a problem with my system:
>>
>> Can you attach /proc/interrupts as well please.
>
> It seems that the radeon thing is just one of the manifestations of the
> problem.
>
> Today, I noticed another bad symptom, when I accidentally booted with kernel
> 3.0 (I have many kernels in GRUB2): I printed a LaTeX document with only 2
> pages of pure text.  My printer is an inkjet printer connected via USB to my
> computer and it took about 6 minutes to print those 2 pages. The printer
> head moved printing something, then it paused a bit, then it printed some
> more, then it paused some more etc.
>
> I just rebooted with 2.6.38 and the very same document was printed in, like,
> 15 seconds...
>
> So, is there anything that I could do to rectify this situation? I can give
> you loads of dumps from here, as long as you tell me what would be useful.
>

Well I was hoping Thomas would help debug this, but he's gone on
holidays, I'll try and take a look next week.

but I've no real idea about the irq subsystem.

Dave.
